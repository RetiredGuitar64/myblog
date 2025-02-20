# WIP

谈起 Crystal 和 Ruby 的区别，就不能不谈性能因素，毕竟很多人离开 Ruby 而采用其他语言，
例如，go、rust、包括 Crystal，都是因为 Ruby 相对而言速度较慢，对吧？

这里主要分析一下使用 Crystal 之后，值得注意的性能相关的因素。

本文部分内容参考自[官方 performance 文档](https://crystal-lang.org/reference/latest/guides/performance.html)

## 不要过早的优化

```
> We should forget about small efficiencies, say about 97% of the time: premature optimization is the root of all evil. 
> Yet we should not pass up our opportunities in that critical 3%.

我们应该忽略那些小效率问题，大约有 97% 的时间：过早优化是万恶之源。然而，在那关键的 3% 时刻，我们不能错失机会。
```

然而，如果你正在编写一个程序，并意识到通过进行一些微小的修改就可以写出一个语义相同且运行速度更快的版本时，你绝对不应该错过这个机会。


你总是应该首先对程序进行剖析，以了解其瓶颈所在。

- 在 macOS 上你可以使用随 XCode 提供的 [Instruments Time Profiler](https://developer.apple.com/library/prerelease/content/documentation/DeveloperTools/Conceptual/InstrumentsUserGuide/Instrument-TimeProfiler.html)，或任何一个 [sample profile](https://stackoverflow.com/questions/11445619/profiling-c-on-mac-os-x) 工具。

- 在 Linux 上，任何能够剖析 C/C++ 程序的工具，如 perf 或 Callgrind，都应能正常工作。更多的例子，见 [如何查找性能瓶颈]()

- 无论是 Linux 还是 OS X，你都可以使用调试器运行程序，然后偶尔按下 `ctrl+c` 中断它，并执行 `gdbbacktrace` 来查看路径追踪中的模式（或者使用 gdb 的穷人版剖析工具，该工具为你做了同样的事情，或者 OS X 的 sample 命令）。

## 如何查找性能瓶颈

FIXME: 这个应该单独放入一个章节

因为本人使用 Linux ，这里以 Arch Linux，介绍 Linux 内核自带的一个性能分析工具 perf 的使用方法。

### 安装 perf

```bash
sudo pacman -S perf
```

同时会安装部分依赖，例如：elfutils libelf 等

### 编译可执行文件

我们以本站用到的 tartrazine 工具为例。

```bash
git clone https://github.com/ralsina/tartrazine && cd tartrazine
```

```bash
git checkout v0.1.0
```

```bash
shards install
```

```bash
crystal build --debug --release src/main.cr -o ./main
```

此时，可以看到可执行文件 `./main` 被创建了。

这里有两点要注意：

- 总是开启 `--debug` 选项，这样才会拥有完整的调试符号信息（等价于 gcc -g 或 clang -g）
- 总是开启 `--release`，llvm 会做很多深层次优化，是否开这个选项，找出的瓶颈结果可能差别很大。

### 使用 perf record 采集性能数据

```bash
perf record --call-graph dwarf -- ./main ./src/tartrazine.cr abap
```

执行此命令时，perf 将运行 `./main` 并记录性能相关的事件，比如 CPU 周期、指令执行、缓存命中率等，
以及采样调用栈（如果启用调用栈捕获的话），它最终会生成一个记录文件，通常命名为 `perf.data`。

这里我们通过 `--call-graph` 来指定 `采集调用栈` 的方式，dwarf 是一种基于 DWARF 调试信息的收集方法，
允许更细粒度和更准确的调用栈采样，它能函数的调用路径和调用关系，支持更复杂的优化代码，但可能会带来一定的性能开销。

### 查看结果

此时可以直接使用 perf report 查看结果。

```bash
perf report -g graph --no-children
```

大概会看到这个样子的结果

<details>
<summary>perf report 输出</summary>

```text
Samples: 6K of event 'cycles:Pu', Event count (approx.): 7418497477
  Overhead  Command  Shared Object         Symbol
+   47.21%  main     main                  [.] *String::char_bytesize_at<Pointer(UInt8)>:Int32                                                               ◆
+   21.24%  main     main                  [.] *Pointer(UInt8)@Pointer(T)#+<Int32>:Pointer(UInt8)                                                            ▒
+   13.83%  main     main                  [.] *String#char_index_to_byte_index<Int32>:(Int32 | Nil)                                                         ▒
+    6.24%  main     main                  [.] *String#char_bytesize_at<Int32>:Int32                                                                         ▒
+    3.03%  main     libpcre2-8.so.0.13.0  [.] 0x0000000000067ddb                                                                                            ▒
+    2.70%  main     libpcre2-8.so.0.13.0  [.] 0x0000000000067de1                                                                                            ▒
+    2.49%  main     main                  [.] *String#to_unsafe:Pointer(UInt8)                                                                              ▒
     0.29%  main     main                  [.] *String#byte_index_to_char_index<Int32>:(Int32 | Nil)                                                         ▒
     0.17%  main     libpcre2-8.so.0.13.0  [.] pcre2_match_8                                                                                                 ▒
     0.14%  main     main                  [.] *Hash(Thread, Pointer(LibPCRE2::MatchData))@Hash(K, V)#find_entry_with_index_linear_scan<Thread>:(Tuple(Hash::▒
     0.13%  main     libgc.so.1.5.4        [.] 0x000000000000970e                                                                                            ▒
     0.10%  main     libgc.so.1.5.4        [.] 0x0000000000009718                                                                                            ▒
     0.09%  main     main                  [.] *Regex+@Regex::PCRE2#match_data<String, Int32, Regex::MatchOptions>:(Pointer(LibPCRE2::MatchData) | Nil)      ▒
```

可以看到，perf 随机采样了大约 6000 条数据，数据类型是 CPU 的时钟周期(clock cycle)，
并根据采样估算总共消耗了 74.18 亿个 CPU 时钟周期。

P 是尽可能精确的采样，u 是用户态(user space), 排除掉内核态，只统计用户程序运行期间的事件

这里可以发现，程序大约 47.21% 的 CPU 时钟周期时间 消耗在 `String::char_bytesize_at` 这个方法/函数上，
明显不正常，为主要性能瓶颈。

</details>

可选的，如果你更喜欢火焰图，可以使用下面的代码生成它，然后使用浏览器查看。


```bash
perf script | stackcollapse-perf.pl | flamegraph.pl > perf.svg
```

你可以在 [FlameGraph github 页面](https://github.com/brendangregg/FlameGraph) 找到所需的 perl 脚本。

但是我们仍然有一个问题，我们知道性能瓶颈来自于：`String::char_bytesize_at`, 但是我们并不知道
瓶颈到底是是这个函数**调用频率过高** 还是 **单次执行时间太长** 造成的。

## 分析函数调用

一个选项是：使用 perf probe 来为指定的函数添加一个追踪目的的 trace points，通俗的讲，叫做给程序**插入探针**

1. 首先我们需要重新编译它，关闭 llvm 方法内联优化，因为这些优化导致上面的方法不是在文本段方法全局可用的符号

```bash
crystal build src/main.cr -o1 --debug
```

2. 然后查看函数的调用次数，确保可以找到指定的符号，并且结果是一个**大写的 "T"**

```bash
nm -C ./main | grep String::char_bytesize_at
# => 00000000000e9390 T *String::char_bytesize_at<Pointer(UInt8)>:Int32
```

3. 为上面指定地址的函数，添加一个探针。

注意，下面的命令需要使用 sudo 来运行，最后传递的地址是上面返回的 16 进制函数地址

```bash
sudo perf probe -x ./main -a 0xe9390

# Added new event:
#  probe_main:abs_e9390 (on 0xe9390 in /home/zw963/Crystal/git/tartrazine/main)
```

4. 运行下面的命令来确保已经插针成功

```bash
sudo perf probe -l
#  probe_main:abs_e9390 (on char_bytesize_at@share/crystal/src/string.cr in /home/zw963/Crystal/git/tartrazine/main)
```

记住 probe_main:abs_e9390, 稍后会用到


5. 重新执行 perf record, 支持的事件类型，选择上面的事件类型


```bash
perf record -e probe_main:abs_e9390 -- ./main src/tartrazine.cr abap
```

这个步骤如果完整跑下来，会花费几分钟时间，并且生成一个很大的的 perf.data（我这里是 20G ）

好在，我们分析函数调用次数，并不需要完整的运行它才能知道，随便小跑一小会儿就好了，然后按下
Ctrl + C 等待 pref record 结束，再使用已知的工具分析它。

也可以使用 timeout 命令，例如，我们只想运行 10 秒钟

```bash
timeout 10s perf record -e probe_main:abs_e9390 -- ./main src/tartrazine.cr abap
```

这次，仅仅写入了 560 的一个 perf.data。

如果你的程序确实需要完整执行综合分析，可以选择让 ./main 处理一个较小的文件，
或减少取样，例如：确保每秒只生成约 1000 个样本

```bash
perf record -e probe_main:abs_e9390 --freq 1000 -- ./main src/tartrazine.cr abap
```

这样生成样本只有 16M 大小，

## 使用 hotspot 分析采样数据

如果你的系统可以安装 [hotspot](https://github.com/KDAB/hotspot)，一款用来分析
perf 的 GUI 工具，你可以使用它来直接打开 `./perf.data` 进行分析.

