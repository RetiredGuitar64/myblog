## 运行代码方式

Crystal 是一门编译型、静态类型的语言，因此你需要先**编译**，再**运行**。

假设你有一个 `foo.cr`:

```crystal
# Crystal
puts "Hello world"
```

你需要首先 build 它 

```bash
$ crystal build foo.cr
```

它在当前文件夹下，创建了一个可执行文件叫做：`foo`，然后你可以运行它。

```bash
$ ./foo
Hello world
```

当作为最终发布版分发时，记得添加 `--release`, 这开启了最高级别的 llvm 优化，它带来了好得多的性能，但需要更长的 build 时间。

当执行基准测试时，请总是记得开启它。

```bash
$ crystal build --release foo.cr
```

`crystal build --help` 来获取更多的帮助。

## 可枚举的(Enumerable)

下面的 Ruby 代码是工作的： 

```ruby
[[1, "A"], [2, "B"]].each do |a, b|
  p a, b
end

# 1
# "A"
# 2
# "B"
```

因为 Enumerable 对象的的元素（这里是一个子数组）作为参数传递给代码块时，会自动根据
代码块参数形参的个数 auto expanding，但是 Crystal 不会自动这样做（这也避免了一些潜在的 bug）


```sh
In 1.cr:1:27

 1 | [[1, "A"], [2, "B"]].each do |a, b|
                               ^
Error: too many block parameters (given 2, expected maximum 1)
```

错误消息告诉我们，期望的代码块参数个数是一个，但是我们提供了两个。

正确的做法是将所有参数使用圆括号括起来，其内部会执行 unpack： `a, b = [1, "A"]`

```crystal
[[1, "A"], [2, "B"]].each do |(a, b)|
  p a, b
end # => ok
```

嵌套的 unpacking 也是可以的。(since 1.10.0)

```crystal
ary = [
  {1, {2, {3, 4}}} # => A Tuple
]

ary.each do |(w, (x, (y, z)))|
  w # => 1

  x # => 2
  y # => 3
  z # => 4
end
```

Ruby 里的 Splat 参数也是支持的。

```crystal
ary = [
  [1, 2, 3, 4, 5],
]

ary.each do |(x, *y, z)|
  x # => 1
  y # => [2, 3, 4]
  z # => 5
end
```

不过，当 Hash 或 NamedTuple 作为可枚举对象传递**键值对**给代码块时，
是不需要 unpacking 直接可以工作的（也比较符合直觉）。


```crystal
{1 => "A",2 => "B"}.each do |a, b|
  p a, b
end

# 1
# "A"
# 2
# "B"
```

```crystal
{foo: 1, bar: 2}.each do |a, b|
  p a, b
end

# :foo
# 1
# :bar
# 2
```

## 迭代器(Iterator)

Crystal 额外引入了 Iterator 类型（等价于 Ruby 中的 Enumerator::Lazy)

通常来说，当调用一个 Enumerable 方法，例如：#each, #map 等，但是没有代码块时，
会返回一个 lazy 的 Iterator 对象。

举个例子：我们希望取出一千万以内的前三个偶数，并将其 ✖️ 3。

```crystal
(1..10_000_000).select(&.even?).map { |x| x * 3 }.first(3) # => [6, 12, 18]
```

上面的写法是工作的，但是建立了数个不必要的中间数组，我们将其分解如下：

```crystal
(1..10_000_000).select(&.even?) # => 返回一个大小为 500 万，元素全是偶数的数组

map { |x| x * 3 } # => 将上面的的所有元素✖️3

first(3) # => 最后取出前三个
```

这带来额外的计算以及不必要的巨大内存消耗，因为我们只对前三个元素感兴趣，
但是却返回了 500 万个，并计算，但最后只取了前三个，其他被抛弃。

更高效的做法，首先通过 each 返回一个 lazy 的 Iterator，因为 Iterator 重新定义了很多 
Enumerable 的方法，例如：上面的 #map, #select, #first, 调用这些方法，返回了一个
包裹调用者 Iterator 对象的新的 Iterator 对象，在调用链的最后，我们仍然得到的是一个新的 
lazy 的 Iterator 对象，没有任何实际计算，

```crystal
(1..10_000_000).each.select(&.even?).map { |x| x * 3 }.first(3) # => #<Iterator::FirstIterator ... >
```

分解如下：

```crystal
(1..10_000_000).each # => <Range::ItemIterator ...>
select(&.even?) # =>  Iterator::SelectIterator(<Range::ItemIterator ...> ... >>
...
first(3) # => #<Iterator::FirstIterator ... >
```

当我们希望取出值时，我们可以再次调用 #each(&) 或 to_a 


```crystal
first_three_iter = (1..10_000_000).each.select(&.even?).map { |x| x * 3 }.first(3)

first_three_iter.each do |x|
  p x # => 直到这里才实际执行计算。
end # => 打印 6, 12, 18

# 因为 Iterator 是单向的，上面已经通过 each(&) 将所有的三个结果都取出了

first_three_iter.to_a # => []，因此 to_a 返回空数组。
```

正如你猜想的那样，你也可以通过 Iterator#next 方法，一个一个的将元素取出。

```crystal
iter = (1..5).each

iter.next # => 1
iter.next # => 2
typeof(iter.next) # => Int32 | Iterator::Stop
```

------------

创建一个新的 Iterator （Ruby 里面叫做 Enumerator) 也是可以的, 需要下面的几步：

1. 创建一个类，并且混入 Iterator(T) 模块
1. 定义一个 #next 方法，返回下一个元素
2. 在达到结尾时，调用 #stop 方法返回一个 Iterator::Stop::INSTANCE

例如，下面是一个 Zeros 类，返回指定数量的 0

```crystal
class Zeros
  include Iterator(Int32)

  def initialize(@size : Int32)
    @produced = 0
  end

  def next
    if @produced < @size
      @produced += 1
      0
    else
      stop
    end
  end
end

zeros = Zeros.new(5)

zeros.each {|e| print e } # => 00000
```

## &. 含义完全不同

Ruby 中，&. 被称作安全调用操作符(Safe Navigation Operator)，例如：

```ruby
nil.upcase.reverse # => NoMethodError: undefined method `upcase' for nil
nil&.upcase&.reverse # => nil 之上使用 &. 调用，不会报错，而是总是返回 nil
```

而 Crystal 中 &. 含义完全不同，如果代码块只有一个代码块参数，且 block 里面只是
在这个参数之上调用一个方法，我们可以使用被称作 block Short one-parameter (invoke) syntax 
（block 短调用形式）的语法，&. 中的 & 代表传递到代码块的第一个参数，在其之上调用 upcase 
方法，直接写做：`&.upcase`, 例如, 下面的两个用法是等价的。

```crystal
["hello", "world"].map {|x| x.upcase }
["hello", "world"].map &.upcase
```

它看起来和 Ruby 版本的 `["hello", "world"].map &:upcase` 相似，但是更强大，因为，
它调用的方法还允许接受参数，甚至允许链式调用。

例如：

```crystal
(1..10).map &.**(3) # 等价于：(1..10).map {|x| x.**(3) }, 结果为：[1, 8, 27, 64, 125, 216, 343, 512, 729, 1000]
["hello", "world"].map(&.upcase.reverse) # => ["OLLEH", "DLROW"]
```
 
## require 用法不同
 
### Crystal 移除了 require_relative 方法

代之，可以直接使用 require 来引用相对路径的文件。
 
```crystal
require "./foo"
```

并且支持和 File.match? 一样的增强版的 shell filename globbing

- `*` 支持任意数量的除了目录分隔符之外的任意字符。

例如：`require "./foo/*"`，匹配 foo 目录下的所有 cr 文件, 但不含子目录。

- `/**` 递归的匹配所有子目录中的 cr 文件

例如：`require "./foo/**"`，匹配 foo 目录以及所有子目录下的所有 cr 文件。

### $CRYSTAL_PATH

类似于 Ruby 在 $RUBYLIB 从前往后中查找 lib 文件夹来确定引用的 gem, Crystal 等价的环境变量
叫做 $CRYSTAL_PATH, 可以通过 `crystal env CRYSTAL_PATH` 来取得这个变量的默认值

```bash
 ╰──➤ $ crystal env CRYSTAL_PATH
lib:/home/zw963/Crystal/bin/../share/crystal/src
```

可以看到，$CRYSTAL_PATH 默认仅仅包含 `当前目录下的 ./lib` 以及本地安装的编译器的 `标准库相对路径`.
`~/Crystal/share/crystal/src`，我们将指定的文件夹加入到到 $CRYSTAL_PATH中，使用冒号（:) 分隔即可。

例如：

```bash
 ╰──➤ $ export CRYSTAL_PATH=new_folder:$(crystal env CRYSTAL_PATH)
lib:/home/zw963/Crystal/bin/../share/crystal/src
 ╰──➤ $ crystal env CRYSTAL_PATH
new_folder:lib:/home/zw963/Crystal/bin/../share/crystal/src
```


### require 查找策略

我们假设这个加入 $CRYSTAL_PATH 的**文件夹**叫做 `CPATH`, 当我们 `require "foo"` 时，会按照如下顺序查找:

- CPATH/foo.cr					(1) 简单的 foo.cr
- CPATH/foo/foo.cr				(2)	foo 替换为 foo/foo.cr
- CPATH/foo/src/foo.cr			(3) 和 (2) 类似，只不过 `第一级` 文件夹后面加了一个 src 文件夹。

上面的 foo 可以扩展成 `a/b/c` 这种形式，例如，`require "foo/bar/baz"`, 会查找：

- CPATH/foo/bar/baz.cr
- CPATH/foo/bar/baz/baz.cr
- CPATH/foo/src/bar/baz.cr

可见仍旧满足上面的策略，只不过将 foo 替换为 foo/bar/baz 而已。


```
注意：require 绝对路径是不支持的。例如：require "/some/aboslote/path"
Crystal 没有类似于 Ruby 中 load 方法的等价物，但是可以通过下面的 
read_file 宏(macro) 来达到同样的目的
```

```crystal
# 这个 macro 相当于把文件 path.cr 里面的内容物理粘贴到宏调用位置
{{ read_file("/some/alsolute/path.cr").id }} 
```


