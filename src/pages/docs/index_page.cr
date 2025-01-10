class Docs::IndexPage < MainLayout
  def page_title
    "前言"
  end

  def sub_title
    "写在开始之前"
  end

  def content
    missing_info "这是一份面向 Ruby (或有类似经验) 开发者的 Crystal 文档。"

    missing_info "目前，Ruby 相关的基础概念会仅仅略过，代之，会着重介绍 Crystal 和 Ruby 的不同，建议在学习 Crystal 之前，掌握一些 Ruby 的基本概念。"

    markdown <<-'HEREDOC'
对于同时具备 C 以及 Ruby 开发经验的程序员来说，Crystal 是一门容易学习的语言。

但是正如 Ruby 一样，在简单的外表下，Crystal 绝非一门简单的语言。

一直以来，为 Crystal 在中国的普及做贡献，都是自己的一个美好愿望，但一直因故未能实现，这次，以 Crystal 官方文档翻译为基础，结合个人在学习过程中，记录下的大量笔记，也算是对自己之前的知识的一个学习和再掌握，希望对读者学习 Crystal 带来帮助。

如有错误，[欢迎提出勘误指正](https://github.com/crystal-china/website/issues).

HEREDOC
  end
end
