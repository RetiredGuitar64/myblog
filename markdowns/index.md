```
对于同时具备系统编程经验（例如 C）以及 Ruby 开发经验的程序员来说，Crystal 是一门
相对容易掌握的语言。
```

```
目前这个版本，写作计划为具有 Ruby (或类似经验) 的开发者的 Crystal 介绍，因此，
现阶段不会特意讲解 Ruby 相关的基础知识，代之，会使用类似当前 "小提示" 对话框的方式
指出 Crystal 和 Ruby 的异同。

建议在学习 Crystal 文档之前，掌握一些 Ruby 的基本概念，会减少很多摩擦。
```

一直以来，为 Crystal 在中国的普及做贡献，都是自己的一个美好愿望，但一直因故未能实现，
这次，以翻译 Crystal 官方文档作为开始，将笔者学习 Crystal 过程中大量的笔记进行整理,
也算是对自己之前的知识的一个学习和再掌握。

正如 Ruby 一样，在看似简单的外表下，Crystal 又绝非一门简单的语言，希望笔者根据自己的
经验，能将这一门让人惊叹、并且唯一的的语言讲解清楚，对读者学习掌握 Crystal 带来帮助。

如有错误，[欢迎提出勘误指正](https://github.com/crystal-china/website/issues).

## 本站技术栈

[本站](https://github.com/crystal-china/website) 自然使用 Crystal 编写，目前用到的库有：

- [baked_file_system_mounter](https://github.com/crystal-china/baked_file_system_mounter), 用于将本站所需的 assets 文件（包含 js, css, 字体，markdown 等）打包进可执行文件，并在部署到新机器后自动 mount。
- [lucky](https://github.com/luckyframework/lucky) 是一个全功能的 web 框架，用来搭建本站以及计划中的论坛。
- [magic-haversack](https://github.com/crystal-china/magic-haversack) 使用 zig cc 来 built 一个 Crystal 静态 bianry（无需 docker ）
- [markd](https://github.com/icyleaf/markd) 用于转换 markdown 格式到网页。
- [tartrazine](https://github.com/ralsina/tartrazine), 用于高亮 markdown 中的代码块。

前端部分，基于本人的喜好，本站**最大限度避免编写Javascript**, 并且本人也基本不会写 CSS，
有希望拿本项目练手的前端小将，欢迎报名！

下面笔者介绍的本站用到的前端项目，都是属于同一个 github 组织 **Big Sky Software** 下的项目。
他们组织的介绍老有意思了：`我们会发现行业中的新兴热点趋势，然后创造出与之`**相反**`的东西`。

- [htmx](https://htmx.org/) 高效率的 HTML 工具(high power tools for HTML)，这个官方介绍很模糊，其实
  作者专门写了本书介绍 [hypermedia](https://hypermedia.systems/) 的概念，建议读一读，非常有意思，这绝对是像我
  这种服务端工程师的最爱。
- [hyperscript](https://github.com/bigskysoftware/_hyperscript) 专门写在页面标签中的 `script` 或 `_` 属性中的脚本，语法非常接近于
  口语话的英文，是 htmx 一个非常好的补充，见本站 [src/components/doc/form.cr](https://github.com/crystal-china/website/blob/master/src/components/doc/form.cr) 中的例子。
- [missing.css](https://missing.style/) 一个非常简陋的 CSS 框架，非常轻量
- [stork](https://github.com/jameslittle230/stork) 很好用的本地全文搜索库，会编译为 wasm 因此性能很好，缺点是中文支持差一点，
  另外，作者不维护了，有点可惜，目前够用吧。

用到的更多库，请分别查看 [shard.yml](https://github.com/crystal-china/website/blob/master/shard.yml)  以及 [pacakge.json](https://github.com/crystal-china/website/blob/master/package.json)。

## 本站如何部署

相比较使用 Ruby, 简直简单到爆！见项目 [README](https://github.com/crystal-china/website/blob/master/README.md) 以及有关 [交叉编译](https://crystal-china.org/docs/cross_compile) 的说明。
