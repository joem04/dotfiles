# Dotfiles

My Arch Linux configuration files.

## Setup

- **OS**: Arch Linux
- **WM**: Sway (Wayland)
- **Bar**: Waybar
- **Terminal**: Alacritty
- **Launcher**: Rofi
- **Shell**: Zsh with Oh My Zsh
- **Prompt**: Starship

## Files

```
.
├── .bashrc              # Bash configuration
├── .bash_profile        # Bash login shell
├── .zshrc               # Zsh configuration
├── .xinitrc             # X11 initialization
├── .gitconfig           # Git configuration
├── pkglist.txt          # All explicitly installed packages
├── pkglist-native.txt   # Official repo packages only
├── pkglist-aur.txt      # AUR packages only
└── .config/
    ├── alacritty/       # Terminal emulator config
    ├── sway/            # Wayland compositor config
    ├── waybar/          # Status bar config
    ├── rofi/            # Application launcher config
    └── starship.toml    # Shell prompt config
```

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
   ```

2. Install packages:
   ```bash
   # Install all packages (review first!)
   sudo pacman -S --needed - < ~/dotfiles/pkglist-native.txt

   # Install AUR packages (using yay or paru)
   yay -S --needed - < ~/dotfiles/pkglist-aur.txt
   ```

3. Create symlinks (or copy files):
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
   ln -sf ~/dotfiles/.config/starship.toml ~/.config/starship.toml
   ```

4. Install Oh My Zsh (if not already installed):
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

## Notes

- SSH keys and history files are excluded via `.gitignore`
- Review configs before symlinking - paths may need adjustment
- Some configs may reference plugins/themes that need separate installation
