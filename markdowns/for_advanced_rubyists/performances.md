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

- 在 Linux 上，任何能够剖析 C/C++ 程序的工具，如 perf 或 Callgrind，都应能正常工作。更多的例子，见 [查找性能瓶颈](/docs/profile)

- 无论是 Linux 还是 OS X，你都可以使用调试器运行程序，然后偶尔按下 `ctrl+c` 中断它，并执行 `gdbbacktrace` 来查看路径追踪中的模式（或者使用 gdb 的穷人版剖析工具，该工具为你做了同样的事情，或者 OS X 的 sample 命令）。

