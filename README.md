# Dotfiles

A collection of configuration files and setup scripts to replicate my development environment. This setup focuses on a terminal-centric workflow using Neovim, Tmux, and Zsh.

## 📂 Configuration Contents

This repository manages configurations for:
* **Neovim** (`nvim/`)
* **Clangd** (`clangd/`)
* **Tmux** (`tmux/`)

---

## 🛠 Toolchain & Purpose

Below is a list of the tools included in this setup and why they are required.

| Tool | Purpose |
| :--- | :--- |
| **Homebrew** | The package manager used to install and manage the tools below. |
| **Neovim** | A hyperextensible Vim-based text editor. |
| **Zsh** | The default shell, configured for speed and interactivity. |
| **Powerlevel10k** | A fast, flexible, and visually pleasing Zsh theme. |
| **fzf** | Command-line fuzzy finder. Essential for navigating files and history quickly. |
| **fd** | A faster, user-friendly alternative to `find`. Used by Neovim for file searching. |
| **bat** | A `cat` clone with syntax highlighting and Git integration. |
| **ripgrep** | A line-oriented search tool that is significantly faster than `grep`. |
| **eza** | A modern replacement for `ls` with icons and colors. |
| **lazygit** | A simple terminal UI for git commands. |
| **git-delta** | A viewer for git and diff output with syntax highlighting. |
| **Clang** | Compiler front-end for C/C++, required for the LSP (clangd). |
| **Tmux** | Terminal multiplexer to manage sessions and split windows. |
| **Shell Color Scripts** | purely for aesthetics; prints random color scripts when the terminal opens. |

---

## 🚀 Installation Guide

Follow these steps in order to set up a new system.

### 1. Install Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Install Core Tools
Install Neovim, shell utilities, and git enhancements.
```bash
brew install nvim fzf fd bat ripgrep eza lazygit git-delta
```

### 3. Setup Zsh
#### A. Install Zsh
Install Zsh using apt or other package manager system wide so that default shell can be changed. If installed using `brew` cannot be made default.
```bash
    sudo apt install zsh
```

#### B. Install Oh My Zsh
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

#### C. Install Powerlevel10k Theme
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git
```

#### D. Install Zsh Plugins
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git] ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

#### E. Update `.zshrc` Open your `~/.zshrc` file and modify the theme and plugins lines:
```bash
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)
```

### 4. Install Clang (via LLVM Script)

This installs the latest stable version of LLVM/Clang.

```bash
wget [https://apt.llvm.org/llvm.sh](https://apt.llvm.org/llvm.sh)
chmod +x llvm.sh
sudo ./llvm.sh <version>
# Example: sudo ./llvm.sh 17
```

### 5. Setup Tmux

#### A. Install Tmux

```bash
brew install tmux
```

#### B. Install TPM (Tmux Plugin Manager)
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### 6. Install Shell Color Scripts
```bash
git clone git@gitlab.com:dwt1/shell-color-scripts.git
cd shell-color-scripts
sudo make install
cd .. && rm -rf shell-color-scripts
```

---

## 🔗 Symlink Configuration
Once the tools are installed, link the configuration files from this repository to your system's `~/.config` directory.

### 1. Clone this repository
```bash
git clone https://github.com/csrohit/dotfiles.git ~/dotfiles
```

### 2. Create Symlinks Note: Back up your existing configs before running these commands.
```bash
# Ensure .config directory exists
mkdir -p ~/.config

# Neovim
ln -sf ~/dotfiles/nvim ~/.config/nvim

# Clangd
ln -sf ~/dotfiles/clangd ~/.config/clangd

# Tmux
# Creates the folder and links the config file specifically
mkdir -p ~/.config/tmux
ln -sf ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
```


### 3. Final Steps

1. Tmux: Open a new tmux session (tmux) and press Prefix + I (default prefix is usually Ctrl+b or Ctrl+a) to install plugins.
2. Neovim: Open nvim and let the package manager (Lazy.nvim or Packer) install dependencies.
