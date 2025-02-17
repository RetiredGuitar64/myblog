## 第一步：首先需要替换所有 '单引号字符串' 到 "双引号字符串"

你可以使用 Ruby 社区中大名鼎鼎的 [rubocop](https://github.com/rubocop/rubocop) 来完成它。

首先安装 rubocop gem, `gem install rubocop`

然后你可以进入 gem 目录，运行[这个脚本](https://github.com/crystal-china/port_ruby_to_crystal/blob/master/bin/rubocop_double_quotes) 执行替换。


## 第二步：对一些重命名的方法名做一些简单的替换。

进入 gem 目录，执行前面提到的 [port_ruby_to_crystal 脚本](https://github.com/crystal-china/port_ruby_to_crystal/blob/master/bin/port_ruby_to_crystal) 即可。

## 第三步：添加必要的类型

作为一个高度依赖于类型推断的静态类型语言，大多数情况下，代码写起来和 Ruby 没什么不同，但是某些特殊的类型，强制类型声明是必须的。

例如：

### 空数组和空哈希

```crystal
ary = [] of String # => 空数组必须指定数组元素的类型。

ary << "Hello" # => ["Hello"]
ary << 123 # => Error: expected argument #1 to 'Array(String)#<<' to be String, not Int32

h = {} of String => String
```

### 包含代码块参数的 block

下面的代码是合法的 Ruby 代码，但是 Crystal 会报错。

```crystal
def foo(&block)
  [1,2,3].map &block
end

foo {|x| x * 2 } # Error: wrong number of block parameters (given 1, expected 0)
```

因为，你没有为 &block 指定签名，默认假设这是一个没有代码块参数的 block，正确的做法是：


```crystal
def foo(&block : Int32 -> Int32)
  [1,2,3].map &block
end

p foo {|x| x * 2 } # => [2, 4, 6]
```

等等

## 第四步，如果 gem 使用了其他 gem，暂时移除或替换它

当前 gem 依赖的其他 gem 可能在 Crystal 不支持或需要寻找替代库, 在这一步，
你可以暂时隔离它，等编译通过后，再寻找 Crystal 中对应的库或自己实现它。

Crystal 没有一个类似于 https://rubygems.org 这样的中心化网站，包含所有的 Ruby gem.

但是社区仍然提供了几个网站，让你可以方便的查找存在的 shards

https://shards.info/

https://shardbox.org/

上面的网站都尝试找一找，也可以去 [官方 forum](forum.crystal-lang.org) 去搜索或提问

要明白的是，很多著名的 shards, 并非托管自 github，可能来自非常小众的托管平台，
例如：https://codeberg.org，https://sr.ht, 甚至使用 git 之外的其他 SCM 系统，例如：fossil


## 第四步：修复编译时错误。

取决于你的 Ruby 代码，如果你没有炫技，使用太多诸如元编程之类的动态特性，这一步可能很简单就可以达到。
否则，可能需要大量的更改，甚至重写，这往往是最困难的一步。

