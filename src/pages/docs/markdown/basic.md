
不属于任何命名空间的类型，常量，宏以及方法, 属于顶级作用域 Program (Ruby 里面叫做 main)
定义在顶级作用域的表达式会被立即执行，而无需像很多其他语言一样，需要定义一个 main 函数。

```crystal
# Defines a method in the top-level scope
def add(x, y)
  x + y
end

# Invokes the add method on the top-level scope
add(1, 2) # => 3
```

你总可以通过 ``::`` 来引用顶级作用域, 甚至是顶级作用域中定义的方法。


```crystal
def hello
  "hello!"
end

class A
  def hello
    ::hello
  end
end

p! A.new.hello # => "hello!"
```

顶级作用域中的变量是 local 的，在方法中无法被看到。

```crystal
x = 1

def add(y)
  x + y # error: undefined local variable or method 'x'
end

add(2)
```

```crystal
Array(Int32).new  # => []
[1, 2, 3]         # Array(Int32)
[1, "hello", 'x'] # Array(Int32 | String | Char)
```
