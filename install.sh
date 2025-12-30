#!/bin/bash

# ==========================================
# 🚀 Rohit's Dotfiles Autoinstaller
# 🎯 Targets: Nvim, Clangd, Tmux, TPM, CLI Tools
# ==========================================

set -e # 🛑 Exit immediately if a command exits with a non-zero status

echo "🚀 Starting Dotfiles Installation..."

# ------------------------------------------
# 🍺 Step 1: Package Manager (Homebrew)
# ------------------------------------------
if ! command -v brew &> /dev/null; then
    echo "🍺 Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # 🔄 Load brew into the current shell session dynamically
    if [ -d "/home/linuxbrew/.linuxbrew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -d "/opt/homebrew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -d "/usr/local/bin" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew already installed."
fi

# ------------------------------------------
# 🧰 Step 2: Modern CLI Power Tools
# ------------------------------------------
echo "📦 Installing CLI Power Tools..."
# ⚡ nvim: Editor | fzf: Fuzzy Finder | fd: Better find
# 🦇 bat: Better cat | eza: Better ls | delta: Better diffs
brew install neovim fzf fd bat ripgrep eza lazygit git-delta

# ------------------------------------------
# 🧬 Step 3: C++ Toolchain (LLVM/Clangd)
# ------------------------------------------
if ! command -v clangd &> /dev/null; then
    echo "🧬 Installing LLVM/Clang toolchain..."
    
    # 📥 Download official LLVM script
    wget https://apt.llvm.org/llvm.sh
    chmod +x llvm.sh
    
    # ⚙️ Installing version 20 (Latest Stable/Dev)
    sudo ./llvm.sh 20
    
    # 🧹 Cleanup script file
    rm llvm.sh
else
    echo "✅ Clangd already installed."
fi

# ------------------------------------------
# 🎨 Step 4: Terminal Aesthetics
# ------------------------------------------
if [ ! -d "$HOME/shell-color-scripts" ]; then
    echo "🎨 Installing shell-color-scripts..."
    
    # 🛠️ Ensure 'make' is available (needed for the install target)
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y make
    fi
    
    # 📥 Clone and Install
    git clone git@gitlab.com:dwt1/shell-color-scripts.git "$HOME/shell-color-scripts"
    cd "$HOME/shell-color-scripts"
    sudo make install
    cd -
else
    echo "✅ shell-color-scripts already installed."
fi

# ------------------------------------------
# 🔗 Step 5: Symlinking Configurations
# ------------------------------------------
echo "🔗 Symlinking configurations to ~/.config..."
mkdir -p "$HOME/.config"

# 📂 Get absolute path of current directory (the repo root)
DOTFILES_DIR=$(pwd)

# 🔄 Force symlink (-sfn handles directories & updates links)
# Syntax: ln -sfn [SOURCE_TARGET] [LINK_NAME]
ln -sfn "$DOTFILES_DIR/nvim" "$HOME/.config/nvim"
ln -sfn "$DOTFILES_DIR/clangd" "$HOME/.config/clangd"
ln -sfn "$DOTFILES_DIR/tmux" "$HOME/.config/tmux"

echo "✅ Symlinks created for Nvim, Clangd, and Tmux."

# ------------------------------------------
# 🧩 Step 6: Tmux Plugin Manager
# ------------------------------------------
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "🪟 Installing Tmux Plugin Manager (TPM)..."
    mkdir -p "$HOME/.tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    echo "✅ TPM already installed."
fi

# ------------------------------------------
# ✨ Step 7: Completion & Next Steps
# ------------------------------------------
echo "✨ Installation Complete!"
echo "-------------------------------------------------------"
echo "📝 Next steps:"
echo "   1. 🔄 Restart your terminal or source your shell config."
echo "   2. ⌨️  Open 'nvim' and wait for Lazy.nvim to sync."
echo "   3. 🌳 Run ':TSUpdate' inside Neovim (Treesitter)."
echo "   4. 🖥️  Open 'tmux', then press 'Ctrl-b' + 'I' to install plugins."
echo "-------------------------------------------------------"
