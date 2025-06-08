---
Feature Name: execution_contexts
Start Date: 2024-02-05
RFC PR: "https://github.com/crystal-lang/rfcs/pull/2"
Issue: "https://github.com/crystal-lang/crystal/issues/15342"
---

# 概述

重新设计 Crystal 中的 MT(multi-method support) 以提高效率.
例如, 在存在 sleeping 线程的时候, 总是避免 block 纤程, 同时允许开发者手动的
创建以及选择不同的 execution contexts 来运行 Fiber.

```
这个特性灵感来自于: Golang 和 Kotlin
```

# 动机 (以及当前情况分析)

## 术语

- **Thread**: 线程, 被操作系统管理的程序 ([wikipedia](https://en.wikipedia.org/wiki/Thread_(computing))).
- **Fiber**: 纤程, 可以 “暂停并稍后恢复” 的工作单元,  ([wikipedia](https://en.wikipedia.org/wiki/Coroutine)), 每个线程上可以同时运行多个纤程。
- **Scheduler**: 调度器，管理程序内部 Fiber 的执行，由 Crystal 内部控制，而非和线程一样，在程序之外由操作系统调度。
- **Event Loop**: 等待特定事件的抽象，例如： timer （等待一小段时间）或 IO （等待一个 socket 变得可读或可写的）
- **Multi-threaded (MT)**: 使用多个线程，Fiber 可以不同的 CPU 核心上并发的(concurrently)以及并行的(parallel)运行
- **Single-threaded (ST)**: 使用单个纤程，Fiber 无法并行(in parallel), 但是并发是可能的。

## 并发（Concurrency）

```
本 RFC 主要讨论 parallelism, 这里仅快速总结一下 concurrency.
```

Fibers(纤程)，其他语言可能被称为 coroutines, lightweight-threds 或 user-threads，是 Crystal 中实现 concurrency 的基础。

Fiber 总是使用 block 方式来调用, 在 block 中的代码，在当前 Fiber 运行时中被执行，并且不会返回任何值 (这点不同于 Kotlin).
纤程中如果有操作导致 block，当前纤程被 blocked 并挂起（suspended)，在稍后 blocked 操作恢复后，纤程可以被恢复（resume).

这里需要理解的关键是，当一个纤程 A 挂起时，另一个纤程 B 会被自动运行，并在 B block 或执行完成之后，等待 event-loop 报告
是继续执行下一个 Fiber C 还是，恢复前一个纤程或其他纤程的运行。

在并发场景下，一个操作系统纤程，可以同时关联很多个纤程，这意味着，可能同一时间总有一个纤程在运行，这就是 concurrency.

例如，以常见的 IO 操作为例，假设我们从一个 socket 读取内容，高速的处理器需要等待慢速的 IO 返回数据，从开发者角度来看，
这个操作是 block 的，此时 CPU 如果什么都不做等待 IO 完成，完全是 CPU 资源的浪费，在并发(concurrency)场景下，此时，
访问 IO 操作的 Fiber 会立即挂起，释放操作系统线程资源去完成其他任务，等 IO 数据返回后，再立即切换回来继续执行。

纤程是 cooperative（协作式的），无法从程序外部中断或抢占，但是纤程所在的线程它自己有可能被操作系统中断或抢占，
进而阻塞在该线程上运行的所有纤程。

不过 “纤程无法被抢占” 并非并发模型的一部分。在未来的演化中，有可能实现，程序内部主动抢占运行时间过长的纤程，
或者在可抢占的点上要求它们主动让出执行权。

Fiber 的创建以及切换都是非常轻量的。

## 并行（Parallelism）

新派生(spawning) 的 fiber 可以可选的允许在当前线程上派发新的 Fiber，来将一些纤程分组在一起，
或者使用简单的轮询(robin-ish) 方式（无法手动指定），派发到某个正在运行的随机线程上。

当前实现，一个 Fiber 只能在之前挂起(suspend)的线程上被恢复(resume)，不可能恢复到另一个线程上。

Thread <=> scheduler <=> event loop(queue)，当前实现它们之间都是 `唯一的一对一` 关系。

从逻辑角度来说，Fiber 应该总是属于一个 scheduler，反倒不太关心具体在那个线程上运行。
因为，也许将来某个实现，Thread 和 scheduler 之间，并非一一对应, 而是 [golang M:N scheduler](https://medium.com/@rezauditore/introducing-m-n-hybrid-threading-in-go-unveiling-the-power-of-goroutines-8f2bd31abc84) 的关系。 
一个 Fiber 恢复时， scheduler 可能选择最空闲的线程，而这个线程和之前挂起时的线程可能是不同的线程。

在不同线程之上运行的 Fibers 可以并行(in parallel) 运行, 但是同一个线程之上运行的
一组纤程，可以并发（concurrency）的方式运行，但是永远不会并行（in parallel）。

同一个线程之上运行的一组纤程，如果操作同一数据，那么这些数据会在 CPU cache 中缓存以提高性能。

如果线程数超过 CPU 可利用线程的数量，或者操作系统非常忙碌，带来大量线程切换，
并不会提高性能，反而有害于性能。

### Fiber 分组

在同一个 Thread 之上运行的一组 Fiber 无法并发(in parallel), 这极大的简化了逻辑，并且
更加快速，因为你不需要担心同组 Fiber 之间的原子同步操作。

## Issues

1. 新派生的 Fiber 使用简单的轮询方式来选择一个新的线程，这有一个问题，它不考虑忙碌的线程，
   Fiber 可能被派发到一个繁忙的线程之上，而同时，另一个线程空闲。

2. scheduler 会等待处理 event loop(queue) 上的事件，当 queue 为空时，这个饥饿的线程
(starving thread) 会立即进入睡眠状态, 甚至其他线程非常忙碌的情况下，而新的 Fiber 
可能继续不断的入队繁忙线程的队列。


### CPU bound fiber blocks other fibers queued on the same thread/scheduler

如果当前 Fiber 是一个 CPU 密集型（CPU bound) 任务, 执行过程中可能没有 `可抢占点`
（preemptible point）来允许同一个分组的其他 Fibers 执行, 显然这些被 blocked 的 
fibers 也没有机会在其他线程上被执行。

最坏的情况下，整个应用程序等待一个 CPU 密集型 fiber 执行完成，而其他有负载的 fibers 
一直被阻塞，这限制了并行性。（理想情况下，负载 Fiber 应该尽可能分布在不同的线程之上）

## 限制

### 无法在运行时控制 threads/scheduler 的数量

目前没有提供 API 来指定初始 threads/schedulers 的数量，也无法调整大小。
变大其实不是一个问题，但是变小，不得不等待 queue 为空才能停止线程。
如果一个 Fiber 执行的是长期 (long running) 操作, 例如：信号处理循环，或日志处理(logger),
这个线程根本无法被停止掉。

### 无法启动一个没有 scheduler/event-loop 的线程

创建一个线程时（例如通过未公开的 Thread.new），也会自动创建对应的 scheduler/event-loop。
这样做会引发许多复杂的潜在问题。

下面的话不好翻译，继续引用原内容

```
Technically we can (`Thread.new` is undisclosed API but can be called), 
yet calling anything remotely related to fibers or the event-loop is dangerous as 
it will immediately create a scheduler for the thread, and/or an event-loop for
that thread, and possibly block the thread from doing any progress if the thread 
puts itself to sleep waiting for an event, or other issues.
```

一个可能的解决方案是，允许创建 `bare` 线程，这样的线程无法 spawning fiber, 新派发
的 Fiber 会被发送到其他线程或报错。

### Fiber 无法独立于 Thread 而存在。

The fiber becomes the sole fiber executing on that thread, for a period of time or forever. No fiber shall be scheduled on that thread anymore. Here are some use cases:

- Run the Gtk or QT main loops, that must run in a dedicated thread, callbacks from the UI may run in that thread and communicate with the rest of the Crystal application, even if it only has one other thread for running all fibers, the communication must be thread safe.
- Executing a slow, CPU-bound, operation can take a while (e.g. calculating a bcrypt password hash) and it will block all progress of other fibers that happen to run on the same thread.
- Again, see issue [#12392](https://github.com/crystal-lang/crystal/issues/12392).

> [!NOTE]
> We could workaround this in the current model. For example by supporting to create a thread without a scheduler and execute some action there. It would work nicely for very long operations (maybe not so with operations that may last for some hundred milliseconds).
>
> That wouldn’t fix issue [#12392](https://github.com/crystal-lang/crystal/issues/12392) however: we can’t have the current thread continue running the current fiber, and actively move the scheduler to another thread to not block the other fibers, otherwise the fibers would run in parallel to the isolated fiber, breaking the contract!

# Guide-level explanation (the proposal)

In the light of the pros (locality) and cons (blocked fibers), I propose to break the "a fiber will always be resumed by the same thread" concept and instead have "a fiber may be resumed by any thread" to enable more scenarios, for example a MT environment with work stealing.

These scenarios don't have to be a single MT environment with work stealing like Go proposes, but instead to have the ability, at runtime, to create environments to spawn specific fibers in.

## Execution contexts

An execution context creates and manages a dedicated pool of 1 or more threads where fibers can be executed into. Each context manages the rules to run, suspend and swap fibers internally.

Applications can create any number of execution contexts in parallel. These contexts are isolated but they shall still be capable to communicate together with the usual synchronization primitives (e.g. Channel, Mutex) that must be thread-safe.

Said differently: an execution context groups fibers together. Instead of associating a fiber to a specific thread, we'd now associate a fiber to an execution context, abstracting which thread(s) they actually run on.

When spawning a fiber, the fiber would by default be enqueued into the current execution context, the one running the current fiber. Child fibers will then execute in the same execution context as their parent (unless told otherwise).

Once spawned a fiber shouldn’t _move_ to another execution context. For example on re-enqueue the fiber must be resumed into it’s execution context: a fiber running in context B enqueues a waiting sender from context A must enqueue it into context A. That being said, we could allow to _send_ a fiber to another context.

## Kinds of execution contexts

The following are the potential contexts that Crystal could implement in stdlib.

**Single Threaded Context**: fibers will never run in parallel, they can use simpler and faster synchronization primitives internally (no atomics, no thread safety) and still communicate with other contexts with the default thread-safe primitives; the drawback is that a blocking fiber will block the thread and all the other fibers.

**Multi Threaded Context**: fibers will run in parallel and may be resumed by any thread, the number of schedulers and threads can grow or shrink, schedulers may move to another thread (M:N schedulers:threads) and steal fibers from each others; the advantage is that fibers that can run should be able to run, as long as a thread is available (i.e. no more starving threads) and we can be shrink the number of schedulers;

**Isolated Context**: only one fiber is allowed to run on a dedicated thread (e.g. `Gtk.main`, game loop, CPU heavy computation), thus disabling concurrency on that thread; the event-loop would work normally (blocking the current fiber, hence the thread), trying to spawn a fiber without an explicit context would spawn into another context specified when creating the isolated context that could default to `Fiber::ExecutionContext.default`.

Precisions:

- The above list isn’t exclusive: there can be other contexts with different rules (for example MT without work stealing).
- Each context isn’t exclusive: an application can start as many contexts in parallel as it needs.
- An execution context should be wrappable. For example we could want to add nursery-like capabilities on top of an existing context, where the EC monitors all fibers and automatically shuts down when all said fibers have completed.

## The default execution context

Crystal starts a MT execution context with work-stealing where fibers are spawned by default. The goal of this context is to provide an environment that should fit most use cases to freely take advantage of multiple CPU cores, without developers having to think much about it, outside of protecting concurrent accesses to a resource or, preferably, using channels to communicate.

It might be configured to run on one thread, hence disabling the parallelism of the default context when needed. Yet, it might still run in parallel with other contexts!

**Note**: until Crystal 2.x the default execution context might be ST by default, to avoid breaking changes, and a compilation flag be required to choose MT by default (e.g. `-Dmt`).

## The additional execution contexts

Applications can create other execution contexts in addition to the default one. These contexts can have different behaviors. For example a context may make sure some fibers will never run in parallel or will have dedicated resources to run in (never blocking certain fibers). Even allow to tweak the threads' priority and CPU affinity for better allocations on CPU cores.

Ideally, anybody could implement an execution context that suits their application, or wrap an existing execution context.

## Examples

1. We can have fully isolated single-threaded execution contexts, mimicking the current MT implementation.

2. We can create an execution context dedicated to handle the UI or game loop of an application, and keep the threads of the default context to handle calculations or requests, never impacting the responsiveness of the UI.

3. We can create an MT execution context for CPU heavy algorithms, that would block the current thread (e.g. hashing passwords using BCrypt with a high cost), and let the operating system preempt the threads, so the default context running a webapp backend won't be blocked when thousands of users try to login at the same time.

4. The crystal compiler doesn’t need MT during the parsing and semantic phases (for now); we could configure the default execution context to 1 thread only, then start another execution context for codegen with as many threads as CPUs, and spawn that many fibers into this context.

5. Different contexts could have different priorities and affinities, to allow the operating system to allocate threads more efficiently in heterogenous computing architectures (e.g. ARM big.LITTLE).

# Reference-level explanation

An execution context shall provide:

- configuration (e.g. number of threads, …);
- methods to spawn, enqueue, yield and reschedule fibers within its premises;
- a scheduler to run the fibers (or many schedulers for a MT context);
- an event loop (IO & timers):

  => this might be complex: I don’t think we can share a libevent across event bases? we already need to have a “thread local” libevent object for IO objects as well as for PCRE2 (though this is an optimization).

  => we might want to move to our own primitives on top of epoll (Linux) and kqueue (BSDs) since we already wrap IOCP (Win32) and a PR for `io_uring` (Linux) so we don’t have to stick to libevent2 limitations (e.g. we may be able to allocate events on the stack since we always suspend the fiber).

Ideally developers would be able to create custom execution contexts. That means we must have public APIs for at least the EventLoop and maybe the Scheduler (at least its resume method), which sounds like a good idea.

In addition, synchronization primitives, such as `Channel(T)` or `Mutex`, must allow communication and synchronization across execution contexts, and thus be thread-safe.

## Changes

```crystal
class Thread
  # reference to the current execution context
  property! execution_context : Fiber::ExecutionContext

  # reference to the current MT scheduler (only present for MT contexts)
  property! execution_context_scheduler : Fiber::ExecutionContext::Scheduler

  # reference to the currently running fiber (simpler access + support scenarios
  # where a whole scheduler is moved to another thread when a fiber has blocked
  # for too long: the fiber would still need to access `Fiber.current`).
  property! current_fiber : Fiber
end

class Fiber
  def self.current : Fiber
    Thread.current.current_fiber
  end

  def self.yield : Nil
    ::sleep(0.seconds)
  end

  property execution_context : Fiber::ExecutionContext

  def initialize(@name : String?, @execution_context : Fiber::ExecutionContext)
  end

  def enqueue : Nil
    @execution_context.enqueue(self)
  end

  @[Deprecated("Use Fiber#enqueue instead")]
  def resume : Nil
    # can't call Fiber::ExecutionContext#resume directly (it's protected)
    Fiber::ExecutionContext.resume(self)
  end
end

def spawn(*, name : String?, execution_context : Fiber::ExecutionContext = Fiber::ExecutionContext.current, &block) : Fiber
  Fiber.new(name, execution_context, &block)
end

def sleep : Nil
  Fiber::ExecutionContext.reschedule
end

def sleep(time : Time::Span) : Nil
  Fiber.current.resume_event.add(time)
  Fiber::ExecutionContext.reschedule
end
```

And the proposed API. There are two distinct modules that each handle a specific
parts:

1. `Fiber::ExecutionContext` is the module aiming to implement the public facing API,
   for context creation and cross context communication; there can only be one
   instance object of an execution context at a time.

2. `Fiber::ExecutionContext::Scheduler` is the module aiming to implement internal API
   for each scheduler; there should be one scheduler per thread, and there may
   be one or more schedulers at a time for a single execution context (e.g. MT).

There is some overlap between each module, especially around spawning and
enqueueing fibers, but the context they're expected to run differ: while the
former need thread safe methods (i.e. cross context enqueues), the latter can
assume thread local safety.

```crystal
module Fiber::ExecutionContext
  # the default execution context (always started)
  class_getter default = MultiThreaded.new("DEFAULT", size: System.cpu_count.to_i)

  def self.current : ExecutionContext
    Thread.current.execution_context
  end

  # the following methods delegate to the current execution context, they expose
  # the otherwise protected instance methods which are only safe to call on the
  # current execution context:

  # Suspends the current fiber and resumes the next runnable fiber.
  def self.reschedule : Nil
    Scheduler.current.reschedule
  end

  # Resumes `fiber` in the execution context. Raises if the fiber
  # doesn't belong to the context.
  def self.resume(fiber : Fiber) : Nil
    if fiber.execution_context == current
      Scheduler.current.resume(fiber)
    else
      raise RuntimeError.new
    end
  end

  # the following methods can be called from whatever context and must be thread
  # safe (even ST):

  abstract def spawn(name : String?, &block) : Fiber
  abstract def spawn(name : String?, same_thread : Bool, &block) : Fiber
  abstract def enqueue(fiber : Fiber) : Nil

  # the following accessors don’t have to be protected, but their implementation
  # must be thread safe (even ST):

  abstract def stack_pool : Fiber::StackPool
  abstract def event_loop : Crystal::EventLoop
end

module Fiber::ExecutionContext::Scheduler
  def self.current : ExecutionContext
    Thread.current.execution_context_scheduler
  end

  abstract def thread : Thread
  abstract def execution_context : ExecutionContext

  # the following methods are expected to only be called from the current
  # execution context scheduler (aka current thread):

  abstract def spawn(name : String?, &block) : Fiber
  abstract def spawn(name : String?, same_thread : Bool, &block) : Fiber
  abstract def enqueue(fiber : Fiber) : Nil

  # the following methods must only be called on the current execution context
  # scheduler, otherwise we could resume or suspend a fiber on whatever context:

  protected abstract def reschedule : Nil
  protected abstract def resume(fiber : Fiber) : Nil

  # General wrapper of fiber context switch that takes care of the gc rwlock,
  # releasing the stack of dead fibers safely, ...
  protected def swapcontext(fiber : Fiber) : Nil
  end
end
```

Then we can implement a number of default execution contexts. For example a
single threaded context might implement both modules as a single type, taking
advantage of only having to deal with a single thread. For example:

```crystal
class SingleThreaded
  include Fiber::ExecutionContext
  include Fiber::ExecutionContext::Scheduler

  def initialize(name : String)
    # todo: start one thread
  end

  # todo: implement abstract methods
end
```

A multithreaded context should implement both modules as different types, since
there will be only one execution context but many threads that will each need a
scheduler. For example:

```crystal
  class MultiThreaded
    include Fiber::ExecutionContext

    class Scheduler
      include Fiber::ExecutionContext::Scheduler

      # todo: implement abstract methods
    end

    getter name : String

    def initialize(name : String, @size : Int32)
      # todo: start @size threads
    end

    def spawn(name : String?, same_thread : Bool, &block) : Fiber
      raise RuntimeError.new if same_thread
      self.spawn(name, &block)
    end

    # todo: implement abstract methods
  end
```

Finally, an isolated context could extend the singlethreaded context, taking
advantage of its —in practice we might want to have a distinct implementation
since we should only have to deal with two fibers (one isolate + one main loop
for its event loop).

```crystal
class Isolated < SingleThreaded
  def initialize(name : String, @spawn_context = Fiber::ExecutionContext.default, &@func : ->)
    super name
    @fiber = Fiber.new(name: name, &@func)
    enqueue @fiber
  end

  def spawn(name : String?, &block) : Fiber
    @spawn_context.spawn(name, &block)
  end

  def spawn(name : String?, same_thread : Bool, &block) : Fiber
    raise RuntimeError.new if same_thread
    @spawn_context.spawn(name, &block)
  end

  # todo: prevent enqueue/resume of anything but @fiber
end
```

### Example

```crystal
# (main fiber runs in the default context)
# shrink the main context to a single thread:
Fiber::ExecutionContext.default.resize(maximum: 1)

# create a dedicated context with N threads:
ncpu = System.cpu_count
codegen = Fiber::ExecutionContext::MultiThreaded.new(name: "CODEGEN", minimum: ncpu, maximum: ncpu)
channel = Channel(CompilationUnit).new(ncpu * 2)
group = WaitGroup.new(ncpu)

spawn do
  # (runs in the default context)
  units.each do |unit|
    channel.send(unit)
  end
end

ncpu.times do
  codegen.spawn do
    # (runs in the codegen context)
    while unit = channel.receive?
      unit.compile
    end
  ensure
    group.done
  end
end

group.wait
```

## Breaking changes

The default execution context moving from 'a fiber is always resumed on the same thread" to the more lenient 'a fiber can be resumed by any thread", this introduces a couple breaking changes over `preview_mt`.

1. Drop the "one fiber will always be resumed on the same thread" assumption, instead:
   - limit the default context to a single thread (disabling parallelism in the default context);
   - or start an additional, single threaded, execution context.

2. Drop the `same_thread` option on `spawn`, instead:
   - limit the default context to a single thread (disables parallelism in the default context);
   - or create a single-threaded execution context for the fibers that must live on the same thread.

3. Drop the `preview_mt` flag and make execution contexts the only compilation mode (at worst introduce `without_mt`):
   - one can limit the default context to a single thread to (disabling parallelism at runtime);
   - sync primitives must be thread-safe, because fibers running on different threads or in different execution contexts will need to communicate safely;
   - sync primitives must be optimized for best possible performance when there is no parallelism;
   - community maintained shards may propose alternative sync primitives when we don’t want thread-safety to squeeze some extra performance inside a single-threaded context.

4. The `Fiber#resume` public method is deprecated because a fiber can't be resumed into any execution context:
   - shall we raise if its context isn't the current one?
   - shall we enqueue into the other context and reschedule? that would change the behavior: the fiber is supposed to be resumed _now_, not later, and the current fiber could be resumed before it (oops);
   - the feature is also not used in the whole stdlib, and only appears within a single spec;
   - raising might be acceptable, and the deprecation be removed if someone can prove that explicit continuations are interesting in Crystal.

> [!NOTE]
> The breaking changes can be postponed to Crystal 2 by making the default execution context be ST, keep supporting `same_thread: true` for ST while MT would raise, and `same_thread: false` would be a NOOP. A compilation flag can be introduced to change the default context to be MT in Crystal 1 (e.g. keep `-Dpreview_mt` but consider just `-Dmt`). Crystal 2 would drop the `same_thread` argument, make the default context MT:N, and introduce a `-Dwithout_mt` compilation flag to return to ST to ease the transition.
>
> Alternatively, since the `-Dpreview_mt` compilation flag denotes an experimental feature, we could deprecate `same_thread` in a Crystal 1.x release, then make it a NOOP and set the default context to MT:1 in a further Crystal 1.y release. Crystal 2 would then drop the `same_thread` argument and change the default context to MT:N.

# Drawbacks

Usages of the `Crystal::ThreadLocalValue` helper class might break with fibers moving across threads. We use this because the GC can't access the Thread Local Storage space of threads. Some usages might be replaceable with direct accessors on `Thread.current` but some usages link a particular object instance to a particular thread; those cases will need to be refactored.

- `Reference` (`#exec_recursive` and `#exec_recursive_clone`): a fiber may be preempted and moved to another thread while detecting recursion (should be a fiber property?)...

> [!CAUTION]
> This might actually be a bug even with ST: the thread could switch to another fiber while checking for recursion. I assume current usages are cpu-bound and never reach a preemptible point, but still, there are no guarantees.

- `Regex` (PCRE2): not affected (no fiber preemption within usages of JIT stack and match data objects);

- `IO::Evented`: will need an overhaul depending on the event loop details (still one per thread? or one per context?);

> [!WARNING]
> The event loop will very likely need an interface to fully abstract OS specific details around nonblocking calls (epoll, kqueue, IOCP, io_uring, …). See [#10766](https://github.com/crystal-lang/crystal/issues/10766).

# Rationale and alternatives

The rationale is to have efficient parallelism to make the most out of the CPU cores, to provide an environment that should usually work, yet avoid limiting the choices for the developer to squeeze the last remaining drops of potential parallelism.

The most obvious alternative would be to keep the current MT model. Maybe we could fix a few shortcomings, for example shrink/resize, start a thread without a scheduler, allow fibers non explicitly marked as same thread to be moved across threads (though it might be hard to efficiently steal fibers), ...

Another alternative would be to implement Go's model and make it the only possible environment. This might not be the ideal scenario, since Crystal can't preempt a fiber (unlike Go) having specific threads might be a better solution to running CPU heavy computations without blocking anything (if possible).

One last, less obvious solution, could be to drop MT completely, and assume that crystal applications can only live on a single thread. That would heavily simplify synchronization primitives. Parallelism could be achieved with multiple processes and IPC (Inter Process Communication), allowing an application to be distributed inside a cluster.

# Prior art

As mentioned in the introduction, this proposal takes inspiration from Go and Kotlin ([coroutines guide](https://kotlinlang.org/docs/coroutines-guide.html)).

Both languages have coroutines and parallelism built right into the language. Both declare that coroutines may be resumed by whatever thread, and both runtimes expose an environment where multiple threads can resume the coroutines.

**Go** provides one execution context: their MT optimized solution. Every coroutine runs within that global context.

**Kotlin**, on the other hand, provides a similar environment to Go by default, but allows to [create additional execution contexts](https://kotlinlang.org/docs/coroutine-context-and-dispatchers.html) with one or more threads. Coroutines then live inside their designated context, which may each be ST or MT.

The **Tokio** crate for **Rust** provides a single-threaded scheduler or a multi-threaded scheduler (with work stealing), but it must be chosen at compilation time. Apparently the MT scheduler is selected by default (to be verified).

# Unresolved questions

## Introduction of the feature

The feature will likely require both the `preview_mt` and `execution_contexts` flags for the initial implementations.

~~Since it is a breaking change from stable Crystal, unrelated to `preview_mt`, MT and execution contexts may only become default with a Crystal major release?~~

~~Maybe MT could be limited to 1 thread by default, and `spawn(same_thread)` be deprecated, but what to do with `spawn(same_thread: true)`?~~

## Default context configuration

This proposal doesn’t solve the inherent problem of: how can applications configure the default context at runtime (e.g. number of MT schedulers) since we create the context before the application’s main can start. 

We could maybe have sensible defaults + lazily started schedulers & threads, which means that the default context would only start 1 thread to run 1 scheduler, then start up to `System.cpu_count` on demand (using some heuristic).

The application would then be able to scale the default context programmatically, for example to a minimum of 4 schedulers which will immediately start the additional schedulers & threads.

# Future possibilities

MT execution contexts could eventually have a dynamic number of threads, adding new threads to a context when it has enough work, and removing threads when threads are starving (always within min..max limits). Ideally the threads could return to a thread pool (up to a total limit, like GOMAXPROCS in Go) and be reused by other contexts.
