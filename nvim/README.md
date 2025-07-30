# Neovim setup for Mac/Linux

<!--toc:start-->
- [Neovim setup for Mac/Linux](#neovim-setup-for-maclinux)
  - [Installation on Ubuntu](#installation-on-ubuntu)
  - [Installation on Mac](#installation-on-mac)
  - [Configuration](#configuration)
<!--toc:end-->

## Installation on Ubuntu

First download the binary image:

```bash
wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb
```

Install the downloaded binary in the system,

```bash
sudo dpkg -i nvim-linux64.deb
```

## Installation on Mac

```bash
brew install neovim
```

## Configuration

Create a directory in `$HOME` directory

```bash
mkdir ~/.config
```

Clone nvim Configuration

```bash
git clone git@github.com:csrohit/nvim-setup.git nvim
```

Run neovim in project folder

```bash
cd <project_dir>
nvim .
```
