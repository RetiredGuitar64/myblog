这是一篇针对 Rubyists 的 Crystal 用法指引，目的是，那些熟练的 Ruby 使用者，可以快速上手 Crystal。

```
这篇指引的部分内容，需要对 Ruby 足够熟悉，才能更好的理解！
```

# 类型

## 字符串

Crystal 使用双引号来表示字符串，单引号是 Char 类型（在栈中分配）。

```crystal
p! typeof("Hello") # => String
p! typeof("汉") # => String
p! typeof('汉') # => Char
```

这可能是从 Ruby 切换到 Crystal 遇到的最大的坑之一。

```
如果你要迁移 Ruby 代码到 Crystal，作为第一步，一个很好的建议是：


使用 [rubocop](https://github.com/rubocop/rubocop) 将代码中的所有字符串改为双引号。
```

Crystal 字符串是不可变的, 因此，Ruby 中常用的方法 `String#<<` 是没有的。

尝试修改一个字符串，例如 String#+ 或 interpolation 都会产生新的字符串，你需要将修改后字符串重新赋值给一个变量。

```crystal
str = "Hello"
p! str.object_id # => 104918042676384
str = str.sub("H", "h")
p! str.object_id # => 132565044809664
```

你仍然可以使用 `%` 或 `%q` 来分别表示 Ruby 中等价的 `"双引号"` 和 `'单引号'` 

```crystal
recipient = "Billy"
p! %(Hello #{recipient}!) # => "Hello Billy!"
p! %q(Hello #{recipient}!) # => "Hello \#{recipient}!"
```

## Crystal 中没有全局变量

Crystal 不支持定义 $ 开头的全局变量，事实上 $ 开头的其实根本不是全局变量，因为只是方法可见的。

默认，只有很少的几个预定义的 $ 开头的变量，正则匹配相关的 $~, $1, $2 ... 以及前一个被执行的进程退出状态 $?

```crystal
"hello" =~ /(ll)o/

p! $~ # => Regex::MatchData("llo" 1:"ll")
p! $0 # => llo, 等价于 $~[0]，等价于 Ruby 中的 $&
p! $1 # => ll，等价于 $~[1]
p! $2 # => Unhandled exception: Invalid capture group index: 2 (IndexError)

`ls -alh`
p! $? # => Process::Status[0]
```

## Bool 类型

## 整数与布尔类型

整数类型细分为 8 个，而 Ruby 是 Integer 一个。

```crystal
p! typeof(1_i8) # => Int8
p! typeof(1_u8) # => UInt8
p! typeof(1_i16) # => Int16
p! typeof(1_u16) # => UInt16
p! typeof(1) # => Int32 这是整数默认类型, 等价于：typeof(1_i32)
p! typeof(1_u32) # => UInt32
p! typeof(1_i64) # => Int64
p! typeof(1_u64) # => UInt64
```

Ruby 中，当数字大到 Fixnum 无法容纳它时，会自动转化为 Bignum, Crystal 则抛出 OverflowError 异常

```crystal
x = 127_i8 # An Int8 type
x          # => 127
x += 1     # Unhandled exception: Arithmetic overflow (OverflowError)
```

Crystal 标准库提供了专门的任意大小和精度的类型

[`BigDecimal`](https://crystal-lang.org/api/BigDecimal.html) | 
[`BigFloat`](https://crystal-lang.org/api/BigFloat.html) |
[`BigInt`](https://crystal-lang.org/api/BigInt.html) |
[`BigRational`](https://crystal-lang.org/api/BigRational.html)

Crystal 中，true/false 类属于 Bool 类型, 而 Ruby 是单独的 TrueClass 和 FalseClass

## 哈希与 NamedTuple

Crystal 当中：哈希火箭表示一个哈希，而 1.9 新哈希表示法

`{:foo => 100}` 这是定义了一个哈希。

`{foo: 100}` 则是定义了一个 NamedTuple

后者是一个不可变的、编译时确定大小的特定的 NamedTuple 类型, 并且是栈分配的，可以简单的将理解为就是一个不可变的 Struct。

```crystal
x = {:foo => 100, :bar => "Hello"}
y = {foo: 100, bar: "Hello"}

p! typeof(x) # => Hash(Symbol, Int32 | String)
p! typeof(y) # => NamedTuple(foo: Int32, bar: String), 编译时类型就是一个包含了整数类型属性 foo, 以及字符串类型属性 bar 的 NamedTuple

# 通过符号和字符串取值都是可以的。
p! y[:foo] # => 100
p! y["foo"] # => 100
```

个人认为这是对 Ruby 错误设计的完美修复，关键字参数本来就应该设计成这样。

## 实例变量和类变量

Crystal 中不存在 Ruby 的类变量那样的东西，Crystal 的 `类变量` 的行为和 Ruby 中 `类的实例变量` 相同。

```crystal
class Foo
  @@value = 1

  def self.value
    @@value
  end

  def self.value=(@@value)
  end
end

class Bar < Foo
end

p Foo.value # => 1
p Bar.value # => 1

Foo.value = 2

p Foo.value # => 2
p Bar.value # => 1

Bar.value = 3

p Foo.value # => 2
p Bar.value # => 3
```

即：`@@类变量` 是属于类自身的变量，每一个子类也会继承父类的类变量值（类型必须相同），
但是会创建自己**独立的**类变量实例, 因此修改子类的类变量的值，不会影响父类，反之亦然。

这是再一次对 Ruby 错误行为的修复。

-----------

因为 Crystal 中的 `@@类变量` 其行为表现就是 Ruby 中的 `类级别` 的 `@实例变量`, 
那么问题来了，Crystal 中类级别定义的实例变量又是什么呢？


```crystal
class Foo
  @value = 100

  def value
    @value
  end

  def initialize
    puts "Foo"
  end
end

class Bar < Foo
end

bar = Bar.new
p! bar.value  # => Crystal 输出 100, Ruby 输出 nil
```

结果为：上面的 @value 其实就是一个普通的实例变量，只不过在类定义中进行了初始化，如果这个类有签名不同的多个不同版本的构造器(initialize 方法)，它相当于为所有构造器初始化了变量 @value，避免了重复初始化。 而且当这样的类被 reopen 时，@value 值也是存在的。

由于目前编译器的限制，在方法定义中初始化一个的可空的实例变量是不合法的。

```crystal
class A
  def initialize
    @x : Int32? 
  end
end

a = A.new 

# 3 | @x : Int32?
# ^-
# Error: declaring the type of an instance variable must be done at the class level
```

即使赋初值为 nil 也不行。

```crystal
class A
  def initialize
    @x : Int32? = nil
  end
end

a = A.new

#  3 | @x : Int32? = nil
#      ^
# Error: instance variable @x of A was inferred to be Nil, but Nil alone provides no information
```

只能通过类级别来初始化

```crystal
class A
  @x : Int32?

  def initialize
  end
end

p! A.new # => #<A:0x7a69c688bfc0 @x=nil>
```

当然，在方法中直接使用 literal 值初始化一个实例变量是可以的。


```crystal
# 但是赋值一个非 nilable 的值，来推断类型是可以的。

class A
  def initialize
    @x = 100
  end
  
  def hello
    @hello = "Hello"
  end
end

p!  A.new # => #<A:0x7d736b629ce0 @x=100, @hello=nil>
```

<table>
<thead>
<tr>
<th></th>
<th>Ruby 用法</th>
<th>Crystal 用法</th>
</tr>
</thead>

<tbody>
<tr>
<td></td>
<td>~~hello~~</td>
<td>~~world~~</td>
</tr>
</tbody>
</table>


# 杂项
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

## 迭代器

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

因为当子数组作为参数传递给代码块时，会自动根据代码块参数形参的个数，auto expanding，
但是 Crystal 不会自动这样做（这也避免了一些潜在的 bug），报错如下

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

## &. 含义完全不同

Ruby 中，&. 被称作安全调用操作符(Safe Navigation Operator)，例如：

```ruby
nil.upcase.reverse # => NoMethodError: undefined method `upcase' for nil
nil&.upcase&.reverse # => nil 之上使用 &. 调用，不会报错，而是总是返回 nil
```

而 Crystal 中 &. 含义完全不同，如果代码块只有一个代码块参数，且 block 的内容是
在这个参数之上调用一个方法，我们可以使用被称作 block Short one-parameter (invoke) syntax，

我称之为 block 短调用形式，&. 中的 & 代表传递到代码块的第一个参数，在其之上调用
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


## 方法的变更

方法的变更非常多，这里不一一列举，只是按照类别简要介绍下：

### Ruby 中很多存在别名的方法, 例如：`Array#length` 和 `Array#size` 一样的，Crystal 仅保留其中之一，

例如：

Array#~~lengh~~ => Array#**size**

Enumerable#~~detect~~ => Enumerable#**find**

Enumerable#~~collect~~ => Enumberable#**map**

### 一些方法名称的语法（习惯）变更，更符合西方人说话的习惯，

例如：

Object#~~respond_to?~~ => Object#responds_to?

Array#~~include?~~ => Array#includes?

File#~~exist?~~ => File#exists?

### 单纯的一些名称换了，换成 Crystal 开发者认为更合适的名字，

例如：

~~attr_reader~~ => getter

~~attr_writer~~ => setter

~~attr_accessor~~ => property

Hash#~~key~~ => Hash#key_for

~~\_\_dir\_\_~~ => \_\_DIR\_\_

这样的变更，使用脚本替换相对简单，可以参考 [port_ruby_to_crystal 脚本](https://github.com/crystal-china/port_ruby_to_crystal/blob/master/bin/port_ruby_to_crystal), 这是一个使用 Ruby 正则表达式编写的脚本，用来对一些 `常见的方法名变更` 做一些简单的替换, 这减少了从 Ruby 迁移到 Crystal 的摩擦。


### 看起来啥都没变，但是方法的部分行为改变了，这可能是个大坑，尤其值得注意

………………………………………………………………………………  Ruby   …………………………………………………………………………   Crystal

------------

Enumerable#each(&)  ………………………… 总是返回 self ………………………………………………………… 总是返回 nil

Array#fetch  …………………………………………  接受一个参数的形式 …………………………………… 需提供第二参数或 `block` 指定默认值

-------------

下面是一个更狡黠的例子。

例如，下面的是完全合法的 Ruby 代码, 它创建了一个新文件 out.txt，并以 a 模式写入字符串 "content"

```ruby
File.write("out.txt", "content", mode = "a")
```

但是，如果在 Crystal 下执行它，会抛出一大堆错误。

```sh
 error in line 0
Error: expanding macro


In <top-level>:1:6

 1 | File.write("out.txt", "content", mode = "a")
          ^----
Error: instantiating 'File.write(String, String, String)'


In /home/zw963/.asdf/installs/crystal/1.15.0/share/crystal/src/file.cr:823:3

 823 | def self.write(filename : Path | String, content, perm = DEFAULT_CREATE_PERMISSIONS, encoding = nil, invalid = nil, mode = "w", blocking = true)
       ^----
Error: instantiating 'write(String, String, String, Nil, Nil, String, Bool)'


In /home/zw963/.asdf/installs/crystal/1.15.0/share/crystal/src/file.cr:824:5

 824 | open(filename, mode, perm, encoding: encoding, invalid: invalid, blocking: blocking) do |file|
       ^---
Error: instantiating 'open(String, String, String, encoding: Nil, invalid: Nil, blocking: Bool)'


In /home/zw963/.asdf/installs/crystal/1.15.0/share/crystal/src/file.cr:741:12

 741 | file = new filename, mode, perm, encoding, invalid, blocking
              ^--
Error: instantiating 'new(String, String, String, Nil, Nil, Bool)'


In /home/zw963/.asdf/installs/crystal/1.15.0/share/crystal/src/file.cr:175:53

 175 | fd = Crystal::System::File.open(filename, mode, perm: perm, blocking: blocking)
                                                       ^
Error: expected argument 'perm' to 'Crystal::System::File.open' to be (File::Permissions | Int32) or File::Permissions, not String

Overloads are:
 - Crystal::System::File.open(filename : String, mode : String, perm : Int32 | ::File::Permissions, blocking)
 - Crystal::System::File.open(filename : String, flags : Int32, perm : ::File::Permissions, blocking _blocking)
```

新手会完全懵逼，不知道发生了什么！看上面第 15 行，会发现一些端倪。

```sh
def self.write(filename, content, perm = DEFAULT_CREATE_PERMISSIONS, encoding = nil, invalid = nil, mode = "w", blocking = true)
```
 

我们发现，File.write 方法的签名中第三个位置参数是 `perm = DEFAULT_CREATE_PERMISSIONS`, 这是不同于 Ruby 实现的。
这个参数要求的类型必须是 DEFAULT_CREATE_PERMISSIONS 而不是 String, 我们通过 mode = "a"，传递字符串 "a" 给 perm，
因此报错，正确的写法应该是使用位置无关的关键字参数：

```crystal
File.write("out.txt", "content", mode: "a")
```

### 一切写起来一样，但是完全不同的东西


………………………………………………………………………………  Ruby   …………………………………………………………………………   Crystal

-------------
alias …………………………………………………………………  创建方法的别名 ……………………………… 为（通常比较复杂的）类型定义一个别名

$0 …………………………………………………………………… 当前程序的名称 …………………前一个正则匹配的内容字符串 (Ruby 中同样的东西是 $&)

&. ……………………………………………………………… 短路运算符 ………………………………………… block 调用简写形式
