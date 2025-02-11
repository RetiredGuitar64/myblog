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

## 使用关键字参数调用方法

```
Crystal 中，当定义一个方法时，无需特殊的语法来声明关键字参数类型，因为他和普通的位置参数是一样的。

当调用一个方法并传递实参进来时，既可以使用正常的**位置参数方式**调用，也可以使用**关键字参数**方式调用
```


```crystal

def say_hello(recipient)
  puts "Hello #{recipient}!"
end

say_hello("Crystal") # => "Hello Crystal!"
say_hello(recipient: "Crystal") # => "Hello Crystal!"
```

Crystal 中提供了一个特殊的语法强制某些参数只能使用关键字参数方式调用。

```crystal
def foo(x, *, y)
end

foo 1, y: 2    # OK
foo y: 2, x: 3 # OK
foo 1, 2 # => Error: missing argument: y
```

## 可枚举的(Enumerable)以及迭代器(Iterator)

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

---------

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
