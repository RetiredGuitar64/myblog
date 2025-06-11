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

当前 Crystal （1.x）版本，默认总是使用单线程执行，语言的 GC （Boehm GC） 例外。

---------

下面是 golang 第一作者，来自 Google 的 Rob Pike 大神 2012 做的 slide 分享及对应视频版本。

[Concurrency is not Parallelism](https://go.dev/talks/2012/waza.slide) 及 [油管视频(带字幕)](https://www.youtube.com/watch?v=oV9rvDllKEg)

