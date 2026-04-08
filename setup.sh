#!/bin/bash
# ─────────────────────────────────────────
#      ADAM'S X - TERMUX SETUP SCRIPT
#         by Adam (@your_tiktok)
# ─────────────────────────────────────────

echo "🚀 Starting ADAM'S X Setup..."

# Update packages
pkg update -y && pkg upgrade -y

# Install everything
pkg install -y git zsh zsh-completions \
  figlet toilet lolcat \
  neovim tmux htop \
  fastfetch ncdu \
  nodejs-lts python pip \
  cmake make clang \
  openssh curl wget \
  lsd tree ripgrep \
  ruby

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install ZSH plugins
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install lolcat
gem install lolcat

# Tmux plugin manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "✅ All packages installed!"
echo "🎨 Setting up configs..."

# ZSH config
cat > ~/.zshrc << 'ZSHEOF'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  command-not-found
)

source $ZSH/oh-my-zsh.sh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Aliases
alias ls='lsd'
alias ll='lsd -la'
alias lt='lsd --tree'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --decorate'
alias vim='nvim'
alias v='nvim'
alias c='clear'
alias ..='cd ..'
alias update='pkg update && pkg upgrade -y'
alias stats='htop'
alias dev='bash ~/layout.sh'
alias ai='node ~/ai-assistant/agent.js'

export TERM=xterm-256color
export COLORTERM=truecolor
export PATH="$HOME/.cargo/bin:$PATH"

# Startup animation
bash ~/.termux_animation.sh
ZSHEOF

# Termux properties
mkdir -p ~/.termux
cat > ~/.termux/termux.properties << 'TEOF'
terminal-font-size=13
terminal-cursor-style=bar
terminal-cursor-blink-rate=600
extra-keys = [['ESC','TAB','|','/','HOME','UP','END','PGUP'],['CTRL','ALT','~','BACKSLASH','LEFT','DOWN','RIGHT','PGDN']]
bell-character=ignore
TEOF

# Dracula colors
curl -fsSL https://raw.githubusercontent.com/dracula/termux/master/colors.properties \
  -o ~/.termux/colors.properties

# Tmux config
cat > ~/.tmux.conf << 'TMUXEOF'
unbind C-b
set -g prefix C-a
bind C-a send-prefix
set -g mouse on
set -g default-terminal "xterm-256color"
set -ag terminal-overrides ",xterm-256color:RGB"
set -g base-index 1
set -g history-limit 10000
set -g status on
set -g status-position bottom
set -g status-style "bg=#1e1e2e,fg=#cdd6f4"
set -g status-left "#[bg=#89b4fa,fg=#1e1e2e,bold] 👑 ADAM'S X #[bg=#1e1e2e] "
set -g status-right "#[fg=#a6e3a1] %H:%M #[fg=#fab387] %d/%m/%Y "
set -g status-left-length 30
set -g status-right-length 40
setw -g window-status-current-format "#[bg=#313244,fg=#89b4fa,bold] #I:#W "
setw -g window-status-format "#[fg=#6c7086] #I:#W "
set -g pane-border-style "fg=#313244"
set -g pane-active-border-style "fg=#89b4fa"
bind | split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
set -g @plugin 'tmux-plugins/tpm'
run '~/.tmux/plugins/tpm/tpm'
TMUXEOF

# Animation script
cat > ~/.termux_animation.sh << 'ANIMEOF'
#!/bin/bash
RED='\033[1;31m'
PINK='\033[1;35m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RESET='\033[0m'

matrix_rain() {
  cols=${COLUMNS:-50}
  rows=${LINES:-20}
  chars='アイウエオカキクケコ0123456789ABCDEFX'
  clear
  for i in $(seq 1 $((rows * 2))); do
    line=""
    for j in $(seq 1 $((cols / 2))); do
      char="${chars:$((RANDOM % ${#chars})):1}"
      if [ $((RANDOM % 3)) -eq 0 ]; then
        line+="\033[1;92m$char "
      else
        line+="\033[1;32m$char "
      fi
    done
    echo -e "$line"
    sleep 0.02
  done
  clear
}

glitch_text() {
  local text="$1"
  local glitch_chars='!@#$%^&*<>?/\|~'
  for i in {1..6}; do
    glitched=""
    for ((j=0; j<${#text}; j++)); do
      if [ $((RANDOM % 3)) -eq 0 ]; then
        glitched+="${glitch_chars:$((RANDOM % ${#glitch_chars})):1}"
      else
        glitched+="${text:$j:1}"
      fi
    done
    echo -ne "\r\033[1;91m$glitched\033[0m"
    sleep 0.07
  done
  echo ""
}

type_text() {
  local text="$1"
  local color="$2"
  for ((i=0; i<${#text}; i++)); do
    echo -ne "${color}${text:$i:1}${RESET}"
    sleep 0.04
  done
  echo ""
}

spinner() {
  local msg="$1"
  local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
  for i in {1..20}; do
    frame=${frames[$((i % 10))]}
    echo -ne "\r\033[1;96m$frame \033[1;95m$msg\033[0m"
    sleep 0.08
  done
  echo -e "\r\033[1;92m✅ $msg\033[0m"
}

wave_line() {
  local cols=${COLUMNS:-50}
  local wave='~≈~≈~≈~≈~≈~≈~≈~≈~≈~≈~≈~≈~≈~≈~≈~≈~≈~≈~≈~≈~≈~'
  for i in {1..3}; do
    echo -e "\033[1;96m${wave:0:$cols}\033[0m"
    sleep 0.1
    echo -e "\033[1;94m${wave:0:$cols}\033[0m"
    sleep 0.1
  done
}

clear
matrix_rain
echo ""
for i in {1..4}; do
  glitch_text "    ADAM'S X - INITIALIZING SYSTEM..."
  sleep 0.1
done
sleep 0.3
clear
echo ""
wave_line
echo ""
type_text "  ADAM'S X - Development Terminal" "$PINK"
type_text "  Android • Node • Firebase • Vercel" "$CYAN"
type_text "  Powered by Termux 🔥" "$GREEN"
echo ""
spinner "Loading ZSH config..."
spinner "Starting dev environment..."
spinner "ADAM'S X Ready!"
echo ""
wave_line
echo ""
toilet -f future "ADAM'S  X" | lolcat
echo ""
fastfetch
echo ""
echo -e "\033[1;92m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\033[1;95m  👑 Welcome back! Ready to build? 🚀\033[0m"
echo -e "\033[1;92m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
ANIMEOF
chmod +x ~/.termux_animation.sh

# Git config
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
git config --global core.editor "nvim"
git config --global init.defaultBranch main
git config --global color.ui true

# Set zsh as default
chsh -s zsh

# Reload
termux-reload-settings

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ ADAM'S X Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "👉 Now restart Termux and enjoy! 🔥"
echo ""
