学习一门语言的第一件事情，就是打印 `Hello World!`, 虽然这在 Crystal 里实在有点无聊。

```crystal
puts "Hello Crystal!"
```

puts 是一个定义在顶级作用域的方法，可以直接被调用。名字是 PUT String 的简写，一个由**双引号**表示的字符串作为参数传递给给这个方法，puts 打印它标准输出(STDOUT)。

方法调用时的括号是可选的。

----------

## 本地变量

一个本地变量必须以 `小写字母` 或 `underscore` _ 开头(后者一般是保留做特殊用途的变量)，由 A-Z, a-z, 0-9 以及 _ 组成

一个本地变量的类型在赋值时自动推断，这里使用 `typeof` 获取一个变量的类型，并使用 `p!` (用作调试目的打印对象内部形式的方法)打印出来

```crystal
message = "Hello Crystal!"

p! typeof(message) # => String
```

变量可以被重新赋值，甚至是**不同类型**的值

```crystal
message = "Hello Crystal!"

p! typeof(message) # => String

message = 73

p! typeof(message) # => Int32
```

--------------

## 字符串

Crystal 中的字符串是由连续的 UTF-8 编码的 unicode 字符组成的，并且是**不可变**的。

空字符(null character, codepoint 0) 在 Crystal 的字符串中仅仅是一个普通字符，并不作为字符串的结尾标志，实际字符串大小，取决于字符串对象的 #size 方法返回值。


```
和 Ruby 不同，单引号字符串，例如：‘Hello' 在 Crystal中是不合法的。

类似于 C，以及 Rust, Crystal 中的字符串必须使用**双引号**表示，例如："Hello!"

单引号则表示 Char, 例如：'A'
```

字符串插值使用 `#{}`, 其中可以使用任何表达式，只要它响应 #to_s (它碰巧在任何对象上都被定义)

```crystal
name = "Crystal"
age = 12
puts "Hello #{name}, Happy #{age}th anniversary!" # => "Hello Crystal, Happy 12th anniversary!"
```
 
转义字符使用反斜杠(backslash) `\`

```crystal
puts "I say: \"Hello World!\"\n\t!"

# => I say: "Hello World!"
#        !
```

为了避免不必要的转义，Crystal 支持使用 %(...) 形式定义字符串。

```crystal
puts %(I say: "Hello World!"\n\t!)

# => I say: "Hello World!"
#        !
```

直接使用 unicode 是支持的，下面的两行字符串输出结果相同：

```crystal
puts "Hello 🌐"
puts "Hello \u{1F310}" # => Hello 🌐
```

[String 类](https://crystal-lang.org/api/latest/String.html) 提供了非常多有用的方法，例如：

```text
String#size		返回字符串大小
String#empty?		字符串是否为空
String#blank?		字符串是否空白（只有白空格whitespace 返回 true)
String#includes?		子串匹配
String#sub		字符串替换
String#index		字符串对应字符索引
String#[]			字符串切片，例如："hello"[1..3] => ell
...
```

查阅 API 文档获取更多的帮助。

## 方法

定义一个方法使用 `def` 关键字，后面跟括号以及参数，括号是可选的，但是建议总是添加。
调用传递参数的方法，括号也是可选的，通常只有在特定场景下，读起来像自然语言且更容易理解时才会省略括号。

```
不同于 Ruby，Crystal 中一个方法，既可以使用**普通方式**调用，也可以使用**关键字参数**方式调用

```


```crystal
def say_hello(recipient)
  puts "Hello #{recipient}!"
end

say_hello("World") # => "Hello World!"
say_hello "Crystal" # => "Hello Crystal!"
say_hello recipient: "Crystal" # => "Hello Crystal!"
```

方法参数允许指定默认值

```crystal
def say_hello(recipient = "World")
  puts "Hello #{recipient}!"
end

say_hello # => "Hello World!"
```

可以精确限制传入参数的类型。

```crystal
def say_hello(recipient : String) # => 限制参数类型必须是 String
  puts "Hello #{recipient}!"
end

say_hello 100 # => Error: expected argument #1 to 'say_hello' to be String, not Int32
```

以及精确限制返回值类型。


```
可以在方法体(body)的任何地方通过 return ??? 语句提前返回方法，传递给 return 的参数将作为返回值。

return 没有任何参数将返回 nil 

否则，方法体中的最后一个表达式将作为返回值。
```

```crystal
def say_hello(recipient : String) : String  # => 限制返回值类型必须是 String
  puts "Hello #{recipient}!"
end

say_hello "Crystal" # => Error: method ::say_hello must return String but it is returning Nil
```


同名方法，可以通过参数名不同，参数个数不同，参数类型不同，返回类型不同进行区分。


参数名不同：

```crystal
def foo(a)
  puts "foo(a)"
end

def foo(b)
  puts "foo(b)"
end

foo(b: 100) # => foo(b)
```

参数个数不同

```crystal
def foo(a，b)
  puts "foo(a, b)"
end

def foo(a)
  puts "foo(a)"
end

foo(100) # => foo(a)
```

参数类型不同

```crystal
def foo(a : String)
  puts "foo(a : String)"
end

def foo(a : Int32)
  puts "foo(a : Int32)"
end

foo(100) # => foo(a : Int32)
```

返回值不同

```crystal
def bar(a : Int32)
  p a
end

def foo(a : String) : String
  "String"
end

def foo(a : String) : Int32
  100
end

bar(foo("Hello")) # => 100
```

--------

## 顶级作用域

不属于任何命名空间的类型，常量，宏以及方法, 属于顶级作用域。

定义在顶级作用域的表达式会被立即执行，而无需像很多其他语言一样，需要定义一个 main 函数。

```crystal
# Defines a method in the top-level scope
def add(x, y)
  x + y
end

# Invokes the add method on the top-level scope
add(1, 2) # => 3
```

```
你总可以通过 ``::`` 来引用顶级作用域中存在的定义, 甚至是定义在顶级作用域的方法。
```

```crystal
def hello
  "Hello in the top-level scope!"
end

A_CONSTANT = "::CONST"

class A
  A_CONSTANT = "A::CONST"
  
  def hello
    ::hello # => 引用上面顶级作用域中定义的 hello method
  end

  def const
    ::A_CONSTANT
  end
end

a = A.new
p! a.hello # => "Hello in the top-level scope!"
p! a.const # => "::CONST"
```

```
顶级作用域中定义的的变量是 local 的，在方法中无法被看到，这点和很多语言，例如，JavaScript, Python，BASH 不同！
```

```crystal
x = 1

def add(y)
  x + y # error: undefined local variable or method 'x'
end

add(2)
```
