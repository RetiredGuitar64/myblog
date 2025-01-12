class Docs::IndexPage < MainLayout
  def page_title
    "前言"
  end

  def sub_title
    "写在开始之前"
  end

  def content
    missing_info "对于同时具备系统编程经验（例如 C）以及 Ruby 开发经验的程序员来说，Crystal 是一门
相对容易掌握的语言。"

    missing_info "
目前这个版本，写作计划为面向 Ruby (或有类似经验) 开发者（例如我自己）的 Crystal 介绍。

因此 Ruby 相关的基础概念会仅仅略过，代之，会着重介绍 Crystal 和 Ruby 的异同。

建议在学习 Crystal 文档之前，掌握一些 Ruby 的基本概念，会减少很多摩擦。
"

    markdown <<-'HEREDOC'

一直以来，为 Crystal 在中国的普及做贡献，都是自己的一个美好愿望，但一直因故未能实现，
这次，以 Crystal 官方文档翻译为基础，辅以个人在学习 Crystal 过程中，记录下的大量笔记，
也算是对自己之前的知识的一个学习和再掌握，

正如 Ruby 一样，在看似简单的外表下，Crystal 又绝非一门简单的语言，希望笔者根据自己的
经验，能将这们让人惊叹的语言讲解清楚，对读者学习掌握 Crystal 带来帮助。


如有错误，[欢迎提出勘误指正](https://github.com/crystal-china/website/issues).

HEREDOC
  end
end
