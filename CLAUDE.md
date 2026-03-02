# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for macOS, Linux, and WSL. All configuration files live under `home/` and are deployed to `$HOME` via `rsync` when `install.sh` runs.

## Installation

```bash
./install.sh   # Deploys home/ to $HOME, installs packages, reloads .zshrc
```

The script must be run with Zsh. Prerequisites: Zsh, Homebrew, and oh-my-zsh (auto-installed if missing).

To re-deploy dotfiles only (without reinstalling packages):
```bash
rsync -av --progress home/ "$HOME" --exclude .git
```

On WSL, `.wezterm.lua` is also copied to the Windows user profile (`%USERPROFILE%`).

## Repository Structure

```
home/               # Mirrors $HOME — all files here are deployed as-is
  .zshrc            # Entry point: sources .scripts/env.sh, oh-my-zsh, eval.sh, keybindings.sh
  .scripts/
    env.sh          # Exports, PATH setup, WSL-specific aliases for .exe programs
    eval.sh         # Tool initializations: fzf, nvm, pyenv, zoxide, atuin
    keybindings.sh  # ZSH keybindings, autosuggest config, shell aliases
    oh-my-zsh.sh    # oh-my-zsh loading
    env.secret.sh   # (not committed) secrets/private env vars sourced last
  .config/nvim/
    init.lua        # Bootstraps lazy.nvim, sets leader keys
    lua/plugins.lua # Neovim plugins: Comment.nvim, nvim-surround
  .config/zellij/   # Zellij config with Catppuccin theme
  .config/alacritty/# Alacritty terminal config
  .wezterm.lua      # WezTerm config (Catppuccin Mocha, MonaspiceNe Nerd Font)
  .gitconfig        # delta pager, rebase-on-pull, VS Code as diff/merge tool
install.sh          # Bootstrap script
```

## Key Conventions

- **Adding a new dotfile**: Place it under `home/` mirroring its `$HOME` path. It will be deployed by the next `install.sh` run or manual `rsync`.
- **Adding packages**: Edit the appropriate array in `install.sh` (`APT_PACKAGES`, `BREW_PACKAGES_LINUX`, `BREW_PACKAGES_MAC`, or `BINARY_URLS_*`).
- **Shell customization**: Aliases and functions go in `.scripts/keybindings.sh`; env vars and PATH in `.scripts/env.sh`; tool `eval` initializations in `.scripts/eval.sh`.
- **Secrets**: Place private env vars in `~/.scripts/env.secret.sh` (not tracked in git, sourced last by `env.sh`).
- **WSL-specific logic**: Gated by `grep -q microsoft /proc/version` checks in `env.sh` and `install.sh`.

## Workflow Rules

- **After editing any file under `home/` or `install.sh`**: Always ask the user if they want to run `./install.sh` to deploy the changes.

## Shell Aliases (from keybindings.sh)

- `ls` → `eza`
- `ze` → `zellij`
- `c` → `code`
- `open` → `explorer.exe` (WSL only)
- `zc <dir>` → `zoxide` jump then open in VS Code
