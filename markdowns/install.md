详细安装教程，请查看 [官方文档](https://crystal-lang.org/install)

这里仅介绍常见的几个系统安装方式：

# Linux

## Debian & RPM

```bash
curl -fsSL https://crystal-lang.org/install.sh | sudo bash
```


## Debian/Ubuntu

```bash
sudo apt install crystal ${hello}
```

## Alpine Linux

```bash
apk add crystal shards ${hello}
```

## Arch linux

```bash
sudo pacman -S crystal
```
## 编译安装

作为 Crystal 语言开发者，编译安装 Crystal 是首选的, 而且可以开启实现性的解释器支持。

以当前最新的 1.15.1 为例, 假设我们希望安装 Crystal 到 ~/Crystal 

### 安装必须的依赖

```bash
pacman -S automake \
       git \
       libevent \
       gmp \
       pcre2 \
       openssl \
       libtool \
       libyaml \
       llvm lld \
       wasmer wasmtime \
    ;
```

### 使用 git clone 官方 github repo

```bash
git clone https://github.com/crystal-lang/crystal.git && git checkout v1.15.1
```

### 编译 Crystal

```bash
install_target=~/Crystal &&
mkdir -p output $install_target/bin $install_target/share $install_target/share/crystal/src/llvm/ext/ &&
make clean
FLAGS="-Dpreview_mt" make crystal interpreter=1 stats=1 release=1
```

### 安装 Crystal

```bash
rm -rf tmp
DESTDIR=$PWD/tmp make install
cp -v tmp/usr/local/bin/crystal $install_target/bin/
rsync -ahP --delete tmp/usr/local/share/ $install_target/share/
```

### 生成并安装静态文档

```bash
rm -rf docs && make docs
rsync -ahP --delete docs/ $install_target/docs
```

这样，你可以直接用浏览器浏览本地的文档 ~/Crystal/docs/index.html

---------


# macOS

## Homebrew 

```bash
brew install crystal
```

## MacPorts

```bash
port install crystal
```

## [tarball](https://github.com/crystal-lang/crystal/releases/download)

-----

# asdf (For linux/macos)

```bash
asdf plugin add crystal
asdf install crystal latest
```


----------


# Windows

# scoop

在一个非超级用户的 PowerShell 终端运行如下命令安装 scoop 到 *C:\Users\<YOUR USERNAME>\scoop*


```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```

运行如下命令安装 Crystal

```powershell
scoop install git
scoop bucket add crystal-preview https://github.com/neatorobito/scoop-crystal
scoop install vs_2022_cpp_build_tools crystal
```

-------


# Docker

```bash
docker pull crystallang/crystal
```
