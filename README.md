# Dotfiles

My Arch Linux configuration files.

## Setup

- **OS**: Arch Linux
- **WM**: Sway (Wayland)
- **Bar**: Waybar
- **Terminal**: Alacritty
- **Launcher**: Rofi
- **Shell**: Zsh with Oh My Zsh

## Files

```
.
├── .bashrc           # Bash configuration
├── .bash_profile     # Bash login shell
├── .zshrc            # Zsh configuration
├── .xinitrc          # X11 initialization
├── .gitconfig        # Git configuration
└── .config/
    ├── alacritty/    # Terminal emulator config
    ├── sway/         # Wayland compositor config
    ├── waybar/       # Status bar config
    └── rofi/         # Application launcher config
```

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
   ```

2. Create symlinks (or copy files):
   ```bash
   # Shell configs
   ln -sf ~/dotfiles/.bashrc ~/.bashrc
   ln -sf ~/dotfiles/.bash_profile ~/.bash_profile
   ln -sf ~/dotfiles/.zshrc ~/.zshrc
   ln -sf ~/dotfiles/.xinitrc ~/.xinitrc
   ln -sf ~/dotfiles/.gitconfig ~/.gitconfig

   # .config directories
   ln -sf ~/dotfiles/.config/alacritty ~/.config/alacritty
   ln -sf ~/dotfiles/.config/sway ~/.config/sway
   ln -sf ~/dotfiles/.config/waybar ~/.config/waybar
   ln -sf ~/dotfiles/.config/rofi ~/.config/rofi
   ```

3. Install Oh My Zsh (if not already installed):
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

## Notes

- SSH keys and history files are excluded via `.gitignore`
- Review configs before symlinking - paths may need adjustment
- Some configs may reference plugins/themes that need separate installation
