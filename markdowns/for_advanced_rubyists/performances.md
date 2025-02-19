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

- 在 Linux 上，任何能够剖析 C/C++ 程序的工具，如 perf 或 Callgrind，都应能正常工作。更多的例子，见 [如何发现性能瓶颈]()

- 无论是 Linux 还是 OS X，你都可以使用调试器运行程序，然后偶尔按下 `ctrl+c` 中断它，并执行 `gdbbacktrace` 来查看路径追踪中的模式（或者使用 gdb 的穷人版剖析工具，该工具为你做了同样的事情，或者 OS X 的 sample 命令）。

## 如何查找性能瓶颈

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

这里我们通过 `--call-graph` 来制定 `采集调用栈` 的方式，dwarf 是一种基于 DWARF 调试信息的收集方法，
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
+    3.50%  main     main                  [.] *Slice(UInt8)@Indexable(T)#rindex<UInt8, Int32>:(Int32 | Nil)
+    2.36%  main     main                  [.] *String#to_s<IO::FileDescriptor+>:Nil
+    2.35%  main     main                  [.] *Hash(String, Tartrazine::Style)@Hash(K, V)#find_entry_with_index<String>:(Tuple(Hash::Entry(String, Tartrazine::Style), Int32) | Nil)
+    2.34%  main     main                  [.] *Pointer(Hash::Entry(Char, String))@Pointer(T)#[]<Int32>:Hash::Entry(Char, String)
+    2.30%  main     main                  [.] *Crystal::Token#value=<String>:String
+    2.29%  main     main                  [.] *Crystal::Token::Kind#newline?:Bool
+    2.26%  main     main                  [.] *Crystal::SyntaxHighlighter::TokenType#symbol?:Bool
+    2.25%  main     main                  [.] *Slice(UInt8)@Slice(T)#[]?<Int32, Int32>:(Slice(UInt8) | Nil)
+    2.22%  main     main                  [.] *Crystal::Lexer#ident_part?<Char>:Bool
+    2.15%  main     main                  [.] *IO::FileDescriptor+@IO::FileDescriptor#unbuffered_write<Slice(UInt8)>:Nil
+    2.14%  main     main                  [.] *Crystal::SyntaxHighlighter::TokenType@Object#===<Crystal::SyntaxHighlighter::TokenType>:Bool
+    2.05%  main     main                  [.] *Pointer(UInt8)@Pointer(T)#[]=<Int32, UInt8>:UInt8
+    2.02%  main     main                  [.] *Char::Reader#decode_current_char:Char
+    2.01%  main     main                  [.] *Crystal::Lexer#next_token:Crystal::Token
+    2.00%  main     main                  [.] *Crystal::Token::Kind#char?:Bool
+    1.99%  main     main                  [.] *String#size:Int32
+    1.96%  main     libc.so.6             [.] 0x0000000000185bd5
+    1.92%  main     main                  [.] *IO::FileDescriptor+@IO::Buffered#write<Slice(UInt8)>:Nil
+    1.91%  main     libgc.so.1.5.4        [.] 0x000000000000a8f5
+    1.87%  main     main                  [.] *IO::FileDescriptor+@IO#check_open:Nil
+    1.85%  main     main                  [.] *String#to_unsafe:Pointer(UInt8)
+    1.83%  main     main                  [.] *Hash(String, String)@Hash(K, V)#key_hash<String>:UInt32
+    1.80%  main     libgc.so.1.5.4        [.] GC_malloc_kind
+    1.78%  main     main                  [.] *Pointer(UInt8)@Pointer(T)#memcmp<Pointer(UInt8), Int32>:Int32
+    1.76%  main     main                  [.] *String#gsub<Hash(Char, String)>:String
+    1.76%  main     main                  [.] *GC::malloc_atomic<UInt64>:Pointer(Void)
+    1.73%  main     main                  [.] *IO::FileDescriptor+@IO#write_string<Slice(UInt8)>:Nil
+    1.73%  main     main                  [.] *Crystal::Hasher#string<String>:Crystal::Hasher
+    1.72%  main     main                  [.] *Array(Docopt::Pattern+)@Array(T)#calculate_new_capacity:Int32
+    1.70%  main     main                  [.] *Pointer(UInt8)@Pointer(T)#copy_to<Pointer(UInt8), Int32>:Point
```

</details>

可选的，如果你更喜欢火焰图，可以使用下面的代码生成它，然后使用浏览器查看。


```bash
perf script | stackcollapse-perf.pl | flamegraph.pl > perf.svg
```

你可以在 [FlameGraph github 页面](https://github.com/brendangregg/FlameGraph) 找到所需的 perl 脚本。


另一款软件 [hotspot](https://github.com/KDAB/hotspot) 可以直接打开 `./perf.data` 进行分析。
