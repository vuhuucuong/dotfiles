# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Overview

Personal dotfiles for macOS, Linux, and WSL. All configuration files live under `home/` and are deployed to `$HOME` via `stow` (symlinks) when `install.sh` runs.

## Installation

```bash
./install.sh   # Deploys home/ to $HOME, installs packages, reloads .zshrc
```

The script must be run with Zsh. Prerequisites: Zsh, Homebrew, and oh-my-zsh (auto-installed if missing).

To re-deploy dotfiles only (without reinstalling packages):
```bash
stow -t "$HOME" --restow --no-folding home
```

On WSL, `.wezterm.lua` is also copied to the Windows user profile (`%USERPROFILE%`).

## Repository Structure

```
home/                              # Mirrors $HOME — deployed as-is
  .zshrc                           # Entry point: sources all .scripts/
  .scripts/
    env.sh                         # Exports, PATH setup, WSL aliases
    eval.sh                        # Tool inits: fzf, nvm, pyenv, zoxide, atuin
    keybindings.sh                 # ZSH keybindings, autosuggest, aliases
    oh-my-zsh.sh                   # oh-my-zsh plugin/theme loading
    env.secret.sh                  # (not committed) private env vars
  .p10k.zsh                        # Powerlevel10k prompt config (Pure style)
  .config/nvim/
    init.lua                       # Bootstraps lazy.nvim, sets leader keys
    lua/plugins.lua                # Plugins: Comment.nvim, nvim-surround
  .config/zellij/
    config.kdl                     # Zellij config with vim-style keybindings
    themes/catppuccin.kdl          # Catppuccin theme variants (latte/frappe/macchiato/mocha)
  .config/alacritty/
    alacritty.toml                 # Alacritty terminal config
  .wezterm.lua                     # WezTerm config (Catppuccin Mocha, MonaspiceNe)
  .gitconfig                       # delta pager, rebase-on-pull, VS Code diff/merge
  .gitignore                       # Global git ignores (macOS, Neovim)
  .editorconfig                    # Code style: LF, UTF-8, 2-space indent
  .tmux.conf                       # Tmux config with Catppuccin theme
  .zsh_plugins.txt                 # Antidote plugin list
  .docker/config.json              # Docker CLI plugins path
  .claude/
    CLAUDE.md                      # Global Claude rules entry point
    context/
      wsl.md                       # WSL path handling rules for Claude
    settings.json                  # Claude Code client settings
    fetch-usage.sh                 # Fetch/cache Claude API usage stats
    statusline-command.sh          # Render usage + context info in statusline
install.sh                         # Bootstrap script (261 lines)
AGENTS.md                          # This file — AI agent guidance
README.md                          # Installation and setup guide
```

## Key Conventions

- **Adding a new dotfile**: Place it under `home/` mirroring its `$HOME` path. It will be deployed by the next `install.sh` run or manual `rsync`.
- **Adding packages**: Edit the appropriate array in `install.sh` (`APT_PACKAGES`, `BREW_PACKAGES_LINUX`, `BREW_PACKAGES_MAC`, or `BINARY_URLS_*`).
- **Shell customization**: Aliases and functions go in `.scripts/keybindings.sh`; env vars and PATH in `.scripts/env.sh`; tool `eval` initializations in `.scripts/eval.sh`.
- **Secrets**: Place private env vars in `~/.scripts/env.secret.sh` (not tracked in git, sourced last by `env.sh`).
- **WSL-specific logic**: Gated by `grep -q microsoft /proc/version` checks in `env.sh` and `install.sh`.
- **Claude context files**: Go under `home/.claude/context/<topic>.md`, imported in `home/.claude/CLAUDE.md` via `@context/<topic>.md`.

## Workflow Rules

- **After editing any file under `home/` or `install.sh`**: Always ask the user if they want to run `./install.sh` to deploy the changes.

---

## Detailed File Reference

### `install.sh`

Bootstrap script. Key sections:

- Verifies shell is Zsh
- Auto-installs oh-my-zsh if missing
- Deploys dotfiles via `stow --restow --no-folding home` (creates symlinks in `$HOME`)
- On WSL: copies `.wezterm.lua` to Windows user profile via `wslpath`
- Binary installs use SHA-256 checksum validation, stored in `~/.local/bin`

**Package arrays:**

| Variable | Contents |
|---|---|
| `APT_PACKAGES` | curl, unzip, htop, iperf3, lsof, rsync, vim, wget, progress, gcc |
| `BREW_PACKAGES_MAC` | jq, fzf, zoxide, antidote, nvm, pyenv, yarn, atuin, neovim, delta, rust, docker, docker-compose, shfmt, pnpm, oven-sh/bun/bun |
| `BREW_PACKAGES_LINUX` | Same as Mac + eza, zellij |
| `BINARY_URLS_MAC` | zellij v0.43.1 (x86_64-apple-darwin) |

**Helper functions:** `_section`, `_require_cmd`, `_finalize_binary`, `check_zsh`, `install_oh_my_zsh`, `check_brew`, `copy_dotfiles`, `install_apt_packages`, `install_brew_packages`, `copy_wezterm_to_windows`

---

### `.zshrc`

Load order:
1. Powerlevel10k instant prompt
2. `~/.scripts/env.sh`
3. Homebrew shellenv (Linux: `/home/linuxbrew/...`, macOS: `/usr/local/bin/brew`)
4. `~/.scripts/oh-my-zsh.sh`
5. `~/.scripts/eval.sh`
6. `~/.scripts/keybindings.sh`
7. `~/.p10k.zsh`

---

### `.scripts/env.sh`

**Exports:** `LC_ALL`, `LANG` (en_US.UTF-8), `ZSH`, `EDITOR=code`, `NVM_DIR`, `PYENV_ROOT`

**PATH additions:** `~/.yarn/bin`, `~/.cargo/bin`, `~/.local/bin`, `/usr/local/opt/curl/bin`

**WSL block** (detected via `grep -qi microsoft /proc/version`):
- Extracts Windows username via `cmd.exe /c "echo %USERNAME%"`
- Adds to PATH: VS Code, Cursor, WezTerm, Windows system dirs
- Creates `.exe` aliases for Windows binaries (excludes `/mnt/c/Windows` to avoid conflicts)
- Sources `~/.scripts/env.secret.sh` if present

**Helper:** `_require_cmd` — returns 1 if a command is not found, used to guard conditional aliases/inits

---

### `.scripts/eval.sh`

Conditionally initializes (all guarded by `_require_cmd`):
- **fzf** — sources `~/.fzf.zsh`
- **NVM** — from Homebrew prefix
- **Pyenv** — `pyenv init`
- **Zoxide** — `zoxide init zsh`
- **Atuin** — `atuin init zsh`

---

### `.scripts/keybindings.sh`

**Paste handling:**
- Overrides `zsh-autosuggestions` paste behavior to avoid lag
- WSL: converts pasted Windows paths (`C:\foo\bar` → `/mnt/c/foo/bar`) via `sed`

**Autosuggest style:** `fg=#b4befe,bold,underline` (Catppuccin Lavender)

**Keybindings:**
- `Ctrl+Space` — accept autosuggest
- `Tab` / `Shift+Tab` — menu complete forward/reverse

**Aliases (guarded by `_require_cmd`):**
- `ls` → `eza`
- `ze` → `zellij`
- `c` → `code`
- `cl` → `claude`

**Functions:**
- `zc [dir]` — zoxide jump then `code .`
- `zcl [dir]` — zoxide jump then `claude .`

---

### `.scripts/oh-my-zsh.sh`

Auto-installs missing plugins via shallow git clone into `~/.oh-my-zsh/custom/`:
- `zsh-users/zsh-syntax-highlighting`
- `zsh-users/zsh-autosuggestions`
- `zsh-users/zsh-completions`
- `romkatv/powerlevel10k` (theme)

**Plugins enabled (23):** git, pip, command-not-found, vi-mode, brew, docker-compose, docker, fzf, gem, node, nvm, sudo, yarn, man, zsh-syntax-highlighting, zsh-autosuggestions, zsh-completions

**Theme:** `powerlevel10k/powerlevel10k`

---

### `.p10k.zsh`

Pure-style Powerlevel10k prompt.

**Left prompt:** `context`, `dir`, `vcs`, `command_execution_time`, then newline + `virtualenv`, `prompt_char` (❯/❮)

**Styling:** magenta on success, red on failure; inserts blank line before each prompt; transparent background.

**Git:** no auto-fetch (`PURE_GIT_PULL=0` equivalent).

---

### `.gitconfig`

| Setting | Value |
|---|---|
| editor | `code --wait` |
| pager | `delta` |
| defaultBranch | `main` |
| pull.rebase | `true` |
| delta.side-by-side | `true` |
| delta.line-numbers | `true` |
| merge.conflictstyle | `zdiff3` |

**URL rewrites:** `git://` → `https://`; `https://github.com/` → `git@github.com:` (SSH preferred)

**Alias:** `tree` — pretty graph log

**Tools:** VS Code for both diff and merge

---

### `.config/nvim/init.lua`

- Bootstraps `lazy.nvim` (clones from GitHub if absent)
- Leader: `Space`, Local leader: `\`
- Clipboard: unset (not shared with system)
- Loads plugins from `lua/plugins.lua`

**Plugins:** `numToStr/Comment.nvim`, `kylechui/nvim-surround` (stable branch)

---

### `.wezterm.lua`

**Default domain:** `WSL:Ubuntu-24.04`

**Font:** MonaspiceNe Nerd Font Mono (14pt); italic variant: MonaspiceRn

**Theme:** Catppuccin Mocha; scrollbar enabled; 8px padding; BlinkingBlock cursor

**Keybindings (ALT-prefix):**

| Key | Action |
|---|---|
| ALT+Shift+H/J/K/L | Split pane left/down/up/right |
| ALT+H/J/K/L | Navigate panes |
| ALT+T / ALT+W | New tab / Close tab |
| ALT+1-9 | Go to tab N |
| ALT+[/] | Prev/Next tab |
| ALT+Q | Close pane |
| ALT+Z | Zoom pane |
| ALT+U/D | Scroll half-page up/down |

---

### `.config/alacritty/alacritty.toml`

**Font:** Iosevka Nerd Font, 14pt

**Theme:** Catppuccin Mocha — background `#1E1E2E`, foreground `#CDD6F4`

---

### `.config/zellij/config.kdl`

**Theme:** catppuccin-mocha (from `themes/catppuccin.kdl`)

`show_startup_tips = false`; `clear-defaults = true` on all keybinding modes

**Mode keybindings (vim-style hjkl throughout):**

| Mode | Notable bindings |
|---|---|
| Pane | hjkl navigate, d/r new pane down/right, f fullscreen, z frames, w float |
| Tab | hjkl navigate, 1-9 jump, n new, x close, r rename |
| Resize | hjkl resize, +/-  grow/shrink all |
| Scroll | hjkl scroll, s search, e edit scrollback |
| Search | n/p next/prev, c/o/w toggle case/whole-word/wrap |
| Global | Ctrl+G lock, Ctrl+Q quit, Ctrl+P/T/N/S/B/H switch modes |

**Plugins:** compact-bar, configuration, filepicker (strider), plugin-manager, session-manager, status-bar, tab-bar, welcome-screen

---

### `.tmux.conf`

**Prefix:** Ctrl+B (secondary: Ctrl+A)

**Plugins (TPM):** catppuccin/tmux (mocha, rounded windows), tmux-sensible, tmux-fzf, tmux-pain-control

**Status:** Application, CPU, Session, Uptime, Battery; mouse enabled

---

### `.claude/settings.json`

```json
{
  "statusline": { "type": "command", "command": "bash ~/.claude/statusline-command.sh" },
  "hooks": {
    "PreToolUse": [{ "command": "bash ~/.claude/fetch-usage.sh &" }],
    "Stop":       [{ "command": "bash ~/.claude/fetch-usage.sh &" }]
  }
}
```

---

### `.claude/fetch-usage.sh`

Fetches Claude API usage and caches to `/tmp/.claude_usage_cache` (15-min TTL).

**Output (4 lines):**
1. 5-hour utilization %
2. 7-day utilization %
3. 5-hour reset timestamp (ISO 8601)
4. 7-day reset timestamp (ISO 8601)

**Token source:** `~/.claude/.credentials.json` OAuth token (cached in `/tmp/.claude_token_cache`)

**API:** `GET https://api.anthropic.com/oauth/usage` — 3s timeout, silent

---

### `.claude/statusline-command.sh`

Renders a rich statusline with Catppuccin Mocha colors:

| Element | Color |
|---|---|
| Model name | Peach `#FAB387` |
| Current directory | Teal `#94E2D5` |
| Git branch | Mauve `#C6A0F6` |
| 5-hour usage + countdown | Yellow `#F9E2AF` |
| 7-day usage + countdown | Sapphire `#74C7EC` |
| Context window % + tokens | Green `#A6E3A1` |

Countdown format: `2d 5h` / `3h 45m` / `30m`. Timezone cached in `/tmp/.claude_tz_cache`.

---

### `.claude/context/wsl.md`

Instructs Claude to auto-convert Windows paths (`C:\` → `/mnt/c/`) and immediately read image files when a Windows path is provided — no prompting.

---

## Shell Aliases Summary

| Alias | Expands to | Condition |
|---|---|---|
| `ls` | `eza` | eza installed |
| `ze` | `zellij` | zellij installed |
| `c` | `code` | code installed |
| `cl` | `claude` | claude installed |
| `open` | `explorer.exe` | WSL only |
| `zc [dir]` | zoxide + `code .` | function |
| `zcl [dir]` | zoxide + `claude .` | function |

## Platform Matrix

| Feature | macOS | Linux | WSL |
|---|---|---|---|
| Homebrew path | `/usr/local/bin/brew` | `/home/linuxbrew/.linuxbrew/bin/brew` | `/home/linuxbrew/.linuxbrew/bin/brew` |
| eza/zellij install | Binary (zellij) | Homebrew | Homebrew |
| WezTerm domain | — | — | `WSL:Ubuntu-24.04` |
| Windows PATH aliases | No | No | Yes (VS Code, Cursor, WezTerm) |
| Paste path conversion | No | No | Yes (C:\ → /mnt/c/) |
| `.wezterm.lua` copy | No | No | Yes → `%USERPROFILE%` |
| Alt key composition | Disabled | — | — |
