#!/usr/bin/env bash
#
# This is a dotfiles installer file

set -e

DOTFILEDIR="$(pwd)"

echo "📂 Starting dotfiles installation..."
echo "🏠 Working directory: ${DOTFILEDIR}"

echo "📄 Copying configuration files to home directory..."
cp .vimrc ~/
cp .opencommit ~/
cp .act ~/
cp .tmux.conf ~/
cp .p10k.zsh ~/
cp .digrc ~/
echo "✅ Configuration files copied successfully"

echo "🔧 Setting up VSCode configuration..."
if [ -d ~/.vscode ]; then
  echo "   Removing existing ~/.vscode directory..."
  rm -rf ~/.vscode
fi
cp -a .vscode ~/.vscode
echo "✅ VSCode configuration set up successfully"

#if ! [ -d ~/.continue ]; then
#  mkdir -p ~/.continue
#fi
#cp .continue/config.json ~/.continue

echo "📦 Setting up tmux plugins..."
if ! [ -d ~/.tmux/plugins ]; then
  echo "   Creating ~/.tmux/plugins directory..."
  mkdir -p ~/.tmux/plugins
fi

if ! [ -d ~/.tmux/plugins/tpm ]; then
  echo "   Cloning tmux plugin manager (tpm)..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo "   Updating tmux plugin manager (tpm)..."
  cd ~/.tmux/plugins/tpm && git pull --quiet 2>&1
fi
echo "✅ Tmux plugins set up successfully"

echo "🎨 Setting up Vim plugins and themes..."
if ! [ -d ~/.vim/pack/plugin/start ]; then
  echo "   Creating ~/.vim/pack/plugin/start directory..."
  mkdir -p ~/.vim/pack/plugin/start
fi

echo "   Setting up vim-airline plugin..."
if ! [ -d ~/.vim/pack/plugin/start/vim-airline ]; then
  echo "     Cloning vim-airline..."
  git clone https://github.com/vim-airline/vim-airline ~/.vim/pack/plugin/start/vim-airline
else
  echo "     Updating vim-airline..."
  cd ~/.vim/pack/plugin/start/vim-airline
  git pull --quiet 2>&1
fi

echo "   Setting up nerdtree plugin..."
if ! [ -d ~/.vim/pack/plugin/start/nerdtree ]; then
  echo "     Cloning nerdtree..."
  git clone https://github.com/preservim/nerdtree.git ~/.vim/pack/plugin/start/nerdtree
else
  echo "     Updating nerdtree..."
  cd ~/.vim/pack/plugin/start/nerdtree
  git pull --quiet 2>&1
fi

echo "   Setting up fzf plugin..."
if ! [ -d ~/.vim/pack/plugin/start/fzf ]; then
  echo "     Cloning fzf..."
  git clone https://github.com/junegunn/fzf.vim.git ~/.vim/pack/plugin/start/fzf
else
  echo "     Updating fzf..."
  cd ~/.vim/pack/plugin/start/fzf
  git pull --quiet 2>&1
fi

echo "   Setting up vim-gitgutter plugin..."
if ! [ -d ~/.vim/pack/plugin/start/vim-gitgutter ]; then
  echo "     Cloning vim-gitgutter..."
  git clone https://github.com/airblade/vim-gitgutter.git ~/.vim/pack/plugin/start/vim-gitgutter
else
  echo "     Updating vim-gitgutter..."
  cd ~/.vim/pack/plugin/start/vim-gitgutter
  git pull --quiet 2>&1
fi

echo "   Setting up vim-fugitive plugin..."
if ! [ -d ~/.vim/pack/plugin/start/vim-fugitive ]; then
  echo "     Cloning vim-fugitive..."
  git clone https://github.com/tpope/vim-fugitive.git ~/.vim/pack/plugin/start/vim-fugitive
else
  echo "     Updating vim-fugitive..."
  cd ~/.vim/pack/plugin/start/vim-fugitive
  git pull --quiet 2>&1
fi

echo "   Setting up vim-polyglot plugin..."
if ! [ -d ~/.vim/pack/plugin/start/vim-polyglot ]; then
  echo "     Cloning vim-polyglot..."
  git clone --depth 1 https://github.com/sheerun/vim-polyglot ~/.vim/pack/plugin/start/vim-polyglot
else
  echo "     Updating vim-polyglot..."
  cd ~/.vim/pack/plugin/start/vim-polyglot
  git pull --quiet 2>&1
fi

echo "   Setting up vim-terraform plugin..."
if ! [ -d ~/.vim/pack/plugin/start/vim-terraform ]; then
  echo "     Cloning vim-terraform..."
  git clone https://github.com/hashivim/vim-terraform.git ~/.vim/pack/plugin/start/vim-terraform
else
  echo "     Updating vim-terraform..."
  cd ~/.vim/pack/plugin/start/vim-terraform
  git pull --quiet 2>&1
fi

echo "   Setting up Vim themes..."
if ! [ -d ~/.vim/pack/themes/start ]; then
  echo "     Creating ~/.vim/pack/themes/start directory..."
  mkdir -p ~/.vim/pack/themes/start
fi

echo "   Setting up vim-code-dark theme..."
if ! [ -d ~/.vim/pack/themes/start/vim-code-dark ]; then
  echo "     Cloning vim-code-dark theme..."
  git clone https://github.com/tomasiser/vim-code-dark ~/.vim/pack/themes/start/vim-code-dark
else
  echo "     Updating vim-code-dark theme..."
  cd ~/.vim/pack/themes/start/vim-code-dark || return
  git pull --quiet 2>&1
fi
echo "✅ Vim plugins and themes set up successfully"

echo "🐚 Setting up Zsh and Oh My Zsh..."
if ! [ -d ~/.oh-my-zsh ]; then
  echo "   Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
  echo "   Oh My Zsh already installed"
fi

echo "   Setting up z jump tool..."
if ! [ -f ~/.z ]; then
  echo "     Downloading z script..."
  curl -L https://raw.githubusercontent.com/rupa/z/master/z.sh -o ~/.z
else
  echo "     z script already exists"
fi

echo "   Setting up .zshrc configuration..."
if ! [ -f ~/.zshrc ]; then
  echo "     Creating .zshrc from template..."
  cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc
else
  echo "     .zshrc already exists"
fi

echo "   Setting up Zsh plugins..."
if ! [ -d ~/.oh-my-zsh/custom/plugins ]; then
  echo "     Creating custom plugins directory..."
  mkdir ~/.oh-my-zsh/custom/plugins
fi

echo "     Setting up zsh-autosuggestions..."
if ! [ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]; then
  echo "       Cloning zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
else
  echo "       Updating zsh-autosuggestions..."
  cd ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
  git pull --quiet 2>&1
fi

echo "     Setting up zsh-syntax-highlighting..."
if ! [ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]; then
  echo "       Cloning zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
else
  echo "       Updating zsh-syntax-highlighting..."
  cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
  git pull --quiet 2>&1
fi

echo "     Setting up conda-zsh-completion..."
if ! [ -d ~/.oh-my-zsh/custom/plugins/conda-zsh-completion ]; then
  echo "       Cloning conda-zsh-completion..."
  git clone https://github.com/conda-incubator/conda-zsh-completion.git ~/.oh-my-zsh/custom/plugins/conda-zsh-completion
else
  echo "       Updating conda-zsh-completion..."
  cd ~/.oh-my-zsh/custom/plugins/conda-zsh-completion
  git pull --quiet 2>&1
fi

echo "     Setting up zsh-tfenv..."
if ! [ -d ~/.oh-my-zsh/custom/plugins/zsh-tfenv ]; then
  echo "       Cloning zsh-tfenv..."
  git clone https://github.com/cda0/zsh-tfenv.git ~/.oh-my-zsh/custom/plugins/zsh-tfenv
else
  echo "       Updating zsh-tfenv..."
  cd ~/.oh-my-zsh/custom/plugins/zsh-tfenv
  git pull --quiet 2>&1
fi

echo "     Setting up zsh-aliases-lsd..."
if ! [ -d ~/.oh-my-zsh/custom/plugins/zsh-aliases-lsd ]; then
  echo "       Cloning zsh-aliases-lsd..."
  git clone https://github.com/yuhonas/zsh-aliases-lsd.git ~/.oh-my-zsh/custom/plugins/zsh-aliases-lsd
else
  echo "       Updating zsh-aliases-lsd..."
  cd ~/.oh-my-zsh/custom/plugins/zsh-aliases-lsd
  git pull --quiet 2>&1
fi

echo "   Downloading Azure CLI completion..."
curl -sL https://raw.githubusercontent.com/Azure/azure-cli/dev/az.completion -o ~/.oh-my-zsh/custom/az.zsh
echo "✅ Zsh and Oh My Zsh set up successfully"

echo "⚙️  Configuring Zsh plugins in .zshrc..."
cd "${DOTFILEDIR}"

tmpfile=$(mktemp)
sed 's/^plugins=.*$/plugins=(git zsh-syntax-highlighting zsh-autosuggestions ubuntu jsontools gh common-aliases conda-zsh-completion zsh-aliases-lsd zsh-tfenv z pip docker)/' ~/.zshrc >"${tmpfile}" && mv "${tmpfile}" ~/.zshrc

if [ -f "${tmpfile}" ]; then
  rm "${tmpfile}"
fi
echo "✅ Zsh plugins configured successfully"

echo "🎨 Setting up Oh My Posh prompt theme..."
if ! [ -d ~/.local/bin/ ]; then
  echo "   Creating ~/.local/bin directory..."
  mkdir -p ~/.local/bin/
fi
if ! [ -d ~/.oh-my-posh/themes/ ]; then
  echo "   Creating ~/.oh-my-posh/themes directory..."
  mkdir -p ~/.oh-my-posh/themes
fi
echo "   Installing Oh My Posh..."
curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.local/bin -t ~/.oh-my-posh/themes
echo "   Installing Meslo font (non-interactive)..."
~/.local/bin/oh-my-posh font install Meslo || echo "     Font installation failed or already installed"
echo "   Copying powerlevel10k theme..."
cp powerlevel10k.omp.json ~/.oh-my-posh/themes/powerlevel10k.omp.json
oh-my-posh disable notice

echo "   Configuring Oh My Posh in shell configurations..."
# shellcheck disable=SC2016
grep -qxF 'eval "$(oh-my-posh init zsh --config ~/.oh-my-posh/themes/powerlevel10k.omp.json)"' ~/.zshrc || echo 'eval "$(oh-my-posh init zsh --config ~/.oh-my-posh/themes/powerlevel10k.omp.json)"' >>~/.zshrc

# shellcheck disable=SC2016
grep -qxF 'eval "$(oh-my-posh init bash --config ~/.oh-my-posh/themes/powerlevel10k.omp.json)"' ~/.bashrc || echo 'eval "$(oh-my-posh init bash --config ~/.oh-my-posh/themes/powerlevel10k.omp.json)"' >>~/.bashrc
echo "✅ Oh My Posh prompt theme set up successfully"

echo "🐍 Configuring Conda (if available)..."
if command -v conda &>/dev/null; then
  echo "   Initializing Conda for all shells..."
  conda init --all --no-user-rc-path 2>&1 || echo "     Conda init failed"
  echo "   Disabling Conda prompt changes..."
  conda config --set changeps1 False 2>&1 || echo "     Conda config failed"
  echo "✅ Conda configured successfully"
else
  echo "   Conda not found, skipping configuration"
fi

echo "📁 Installing lsd (modern ls replacement) on Linux..."
if [[ "$(uname)" == "Linux" ]]; then
  if ! command -v lsd &>/dev/null; then
    echo "   Downloading and installing lsd..."
    curl -L https://github.com/lsd-rs/lsd/releases/download/v1.0.0/lsd-v1.0.0-x86_64-unknown-linux-gnu.tar.gz -o lsd.tar.gz
    tar -zxf lsd.tar.gz
    mv lsd-v1.0.0-x86_64-unknown-linux-gnu/lsd ~/.local/bin/
    rm -rf lsd-v1.0.0-x86_64-unknown-linux-gn* lsd.tar.gz
    echo "✅ lsd installed successfully"
  else
    echo "   lsd already installed"
  fi
else
  echo "   Not on Linux, skipping lsd installation"
fi

echo "⚡ Setting up PowerShell profile..."
if [ -n "${AZUREPS_HOST_ENVIRONMENT}" ]; then
  echo "   Detected Azure PowerShell environment"
  if ! [ -d ~/.config/PowerShell/ ]; then
    echo "     Creating ~/.config/PowerShell directory..."
    mkdir -p ~/.config/PowerShell
  fi
  echo "     Copying PowerShell profile..."
  cp Microsoft.PowerShell_profile.ps1 ~/.config/PowerShell/Microsoft.PowerShell_profile.ps1
  echo "✅ PowerShell profile set up for Azure environment"
else
  echo "   Standard environment detected"
  if command -v az &>/dev/null; then
    echo "     Configuring Azure CLI auto-upgrade..."
    az config set auto-upgrade.enable=yes --only-show-errors
    az config set auto-upgrade.prompt=no --only-show-errors
  fi
  if ! [ -d ~/.config/powershell/ ]; then
    echo "     Creating ~/.config/powershell directory..."
    mkdir -p ~/.config/powershell
  fi
  echo "     Copying PowerShell profile..."
  cp Microsoft.PowerShell_profile.ps1 ~/.config/powershell/Microsoft.PowerShell_profile.ps1
  echo "✅ PowerShell profile set up successfully"
fi

echo "🏗️  Setting up Terraform version manager (tfenv)..."
if ! [ -d ~/.tfenv ]; then
  echo "   Cloning tfenv repository..."
  git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv
else
  echo "   Updating tfenv..."
  cd ~/.tfenv
  git pull --quiet 2>&1
fi
echo "   Initializing tfenv..."
~/.tfenv/bin/tfenv init 2>&1 || echo "     tfenv init failed or already initialized"
echo "   Installing latest Terraform version..."
~/.tfenv/bin/tfenv install 2>&1 || echo "     tfenv install failed or already installed"
echo "   Setting Terraform version..."
~/.tfenv/bin/tfenv use 2>&1 || echo "     tfenv use failed or version already set"
echo "✅ Terraform version manager set up successfully"

#if command -v pwsh &> /dev/null; then
#  pwsh -NoProfile -NonInteractive -Command "Install-Module -Name Terminal-Icons -Repository PSGallery -AllowClobber -Force" || continue
#  pwsh -NoProfile -NonInteractive -Command "Install-Module -Name z -Repository PSGallery -AllowClobber -Force" || continue
#fi

#sed -i '' "1s|^|export PATH=\$HOME/.local/bin:\$PATH\n|" ~/.zshrc

echo "🎉 Dotfiles installation completed successfully!"
echo "💡 Please restart your terminal or run 'source ~/.zshrc' to apply all changes."
