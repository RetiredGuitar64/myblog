一部分内容翻译自 https://crystal-lang.org/reference/latest/guides/concurrency.html
有可能一部分信息已经过时了，会随时更正。


我们经常会谈起并行(in parallel)和并发（concurrent），他们其实是两个不同的东西。

一个并发的系统，是指能够处理多个任务的系统，虽然，不一定是同时执行的。

你可以想象自己在厨房做菜，你切一个洋葱，放到油锅里炸的同时，你再切一份番茄。
但是你并没有在同一时间做所有事情，你需要分配你的时间来做上面不同的事情，这是并发。
而并行，则是在同一时间，左手炸洋葱，右手切番茄。

截至这篇文章写作日期(2025年六月)，Crystal 已经完成了 execution context 的 
RFC 大部分开发，在 Crystal 1.16.3 中，已经可以直接使用类似于 golang 的 M:N 混合线程模型，
但是默认并没有开启，需要通过打开 -Dpreview_mt -Dexecution_context 编译时标记来开启。

在当前 1.X 版本 Crystal 中，除了语言的 GC（[Boehm GC](https://en.wikipedia.org/wiki/Boehm_garbage_collector)）使用单独的一个线程之外，
默认总是使用单线程模式执行，在未来的 2.X 版本中，会默认开启多线程模式。

下面介绍 Crystal 实现 concurrency 的一些基础概念：

## Fibers

Fiber 的概念，类似于 Erlang/Elixir, go 中轻量级用户线程, 不同于操作系统线程(Thread)
的`抢占式`( pre-emptive), 它是`协作式`(cooperative)的。

纤维（Fibers），与线程不同，是协作式的。线程是抢占式的：操作系统可以在任何时候中
断一个线程并开始执行另一个线程

- `轻量`，是因为它可以轻易创建成千上万，而相比较操作系统线程，非常少的开销，它虽然
  拥有一个与之关联的 8M 堆栈内存空间（和线程一样的），但是其初始只实际占用 4K 内存空间。

- `用户线程`，是因为它被程序语言自己管理，而不是由操作系统管理它。

- `协作式`，操作系统可以在任何时候中断一个线程并开始执行另一个线程, 而协作式，必须
  明确的通知运行时调度器，其可以切换到其他纤程。例如，如果一个协程需要等待 I/O 操作完成，
  它会告诉调度器：“你看，我必须等待这个 I/O 操作可用，你可以继续执行其他协程，
  并在 I/O 准备好后回来唤醒我。”

Crystal 程序可以创建任意多的 Fiber, Crystal 来确保在合适的时候执行它。

---------

下面是 golang 第一作者，来自 Google 的 Rob Pike 大神 2012 做的 slide 分享及对应视频版本。

[Concurrency is not Parallelism](https://go.dev/talks/2012/waza.slide) 及 [油管视频(带字幕)](https://www.youtube.com/watch?v=oV9rvDllKEg)

