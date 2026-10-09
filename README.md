# Acedia-Shell

**A personal Arch Linux desktop environment built around Hyprland, QuickShell, and a cohesive, wallpaper-driven aesthetic.**

Acedia embraces the art of sloth: a desktop that feels effortless, stays out of the way, and makes everyday interactions feel natural.

## Preview

Take a look at Acedia-Shell in action.



https://github.com/user-attachments/assets/70e3cc10-dff8-4af4-8046-79653adf5496



## Features

- **Hyprland**: Wayland compositor and desktop configuration.
- **QuickShell**: Custom shell components, desktop bar, launcher, wallpaper interface, and notifications.
- **Hyprlock**: Minimal lock screen with a profile image, date, time, password input, and power actions.
- **Matugen**: Generates application colors from your wallpaper.
- **Rofi**: Application launcher and themed interfaces.
- **Zsh**: Customized shell prompt and startup experience.
- **Automatic backups**: The installer backs up existing configurations before replacing them.

## Requirements

Acedia-Shell is designed for **Arch Linux or an Arch-based distribution** running a Wayland session.

### Core packages

| Package | Purpose |
|---|---|
| `hyprland` | Wayland compositor |
| `quickshell-git` | Custom desktop shell and notification service |
| `hyprlock` | Screen locker |
| `matugen` | Wallpaper-based color generation |
| `rofi` | Application launcher and theme |
| `zsh` | Interactive shell |
| `kitty` | Terminal emulator |
| `fastfetch` | System information display |
| `git` | Clone and manage the repository |

Some packages may come from the AUR rather than the official Arch repositories. In particular, Acedia-Shell was developed with `quickshell-git`.

### Fonts

The configuration uses **JetBrainsMono Nerd Font**. Install it to ensure the interface and terminal prompt render as intended.

### Additional dependencies

Some features may depend on additional utilities referenced by your local configuration, such as wallpaper tools, screenshot utilities, clipboard helpers, or scripts.

Check the commands used by the files in `hypr/`, `quickshell/`, and `.zshrc` before installing on a fresh system. Dependencies can change as the project evolves.

## Installation

### 1. Install the dependencies

Install the core packages and any additional utilities required by your configuration.

For example, packages available in the official repositories can be installed with:

```bash
sudo pacman -S hyprland hyprlock matugen rofi zsh kitty fastfetch git
```

Install `quickshell-git` separately using your preferred AUR helper.

> Review the package list against your current configuration before running the installer. This repository configures your desktop; it does not automatically install every system dependency.

### 2. Clone the repository

```bash
git clone https://github.com/gc-MayankPun/Acedia-Shell.git
cd Acedia-Shell
```

### 3. Run the installer

```bash
chmod +x install.sh
./install.sh
```

The installer applies the configurations and backs up existing Hyprland, Hyprlock, QuickShell, and Zsh configurations before replacing them.

**Backups:** Existing configuration directories and `.zshrc` are renamed with a timestamp suffix, such as `hypr_bak_20261010_012600`.

Review `install.sh` before running it so you know which files will be replaced.

### 4. Start using the configuration

Log into your Hyprland session and follow the keybindings and startup behavior defined in the installed configuration.

If a component does not start, launch it manually from a terminal to inspect its error output.

## Repository structure

```text
Acedia-Shell/
├── hypr/                  # Hyprland configuration
├── hyprlock/              # Screen locker configuration
├── quickshell/            # Desktop shell and UI modules
├── matugen/
│   ├── config.toml        # Matugen template configuration
│   └── theme/
│       └── Acedia.rasi    # Rofi theme
├── .zshrc                 # Zsh configuration
└── install.sh             # Configuration installer
```

The QuickShell directory contains the shell entry point, reusable components, feature modules, configuration, and supporting scripts.

## Dynamic theming

Matugen generates colors from an image and writes them to configured application files.

Generate a palette from a wallpaper:

```bash
matugen image ~/Pictures/Wallpapers/wallpaper.jpg
```

Matugen processes the templates configured in `matugen/config.toml`. Generated colors can be used by applications such as Rofi and other integrations configured on your system.

The Rofi theme included in this repository is installed to:

```text
~/.local/share/rofi/themes/Acedia.rasi
```

The installer copies the Matugen configuration to:

```text
~/.config/matugen/config.toml
```

Keep source templates separate from generated output. Generated files may be overwritten whenever Matugen runs.

## Configuration and customization

- **Hyprland:** Edit files under `hypr/`.
- **Hyprlock:** Edit `hyprlock/hyprlock.conf`.
- **QuickShell:** Customize components and feature modules under `quickshell/`.
- **Matugen:** Adjust `matugen/config.toml` and its templates.
- **Rofi:** Customize `matugen/theme/Acedia.rasi`.
- **Zsh:** Customize `.zshrc`.

After changing a configuration, reload or restart the relevant application when necessary.
