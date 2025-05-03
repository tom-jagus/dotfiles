# 🛠️ Git Configuration

This document describes the Git setup used in this dotfiles repository, including GitHub Flow wrapper aliases, configuration file structure, and cross-platform setup scripts.

---

## 📦 Directory Structure

```plaintext
dotfiles/
├── git/
│   └── config              # Git aliases and core settings
├── .setup/
│   └── scripts/
│       ├── setup_git_config.sh   # Unix-based setup script
│       └── setup_git_config.ps1  # Windows PowerShell script
└── .gitconfig              # User-specific Git config (modified by setup scripts)
```

## 🔗 Git Config Inclusion

Instead of managing the entire .gitconfig in this repo, I modularize Git settings by including this line in personal Git config:

```plaintext
[include]
    path = ~/.config/git/config
```

This points to the shared, version-controlled settings inside the dotfiles repo.

## 🚀 Setup instructions

### Linux/macOS (or Git Bash on Windows):

```bash
bash ~/.config/.setup/scripts/setup_git_config.sh
```

This script:

- Ensures ~/.gitconfig exists
- Appends the [include] section if missing
- Points to your shared ~/.config/git/config file

### Windows (PowerShell):

```powershell
powershell -ExecutionPolicy Bypass -File $HOME\.config\.setup\scripts\setup_git_config.ps1
```

This script:

- Converts Windows path to Unix-style forward slashes
- Writes correct include syntax using ASCII encoding
- Appends it safely to your .gitconfig

## 🧩 GitHub Flow Wrapper (git hf)

To simplify GitHub Flow branching, we define a single alias git hf that supports multiple subcommands:

### ✅ Supported Commands

| Command                | Action                                        |
| ---------------------- | --------------------------------------------- |
| git hf feat <name>     | Create feat/<name> from updated main          |
| git hf fix <name>      | Create fix/<name> from updated main           |
| git hf test <name>     | Create test/<name> for experiments            |
| git hf docs <name>     | Create docs/<name> for documentation changes  |
| git hf refactor <name> | Create refactor/<name> for structural updates |
| git hf done <branch>   | Merge branch into main, delete local/remote   |
| git hf drop <branch>   | Force delete local and remote branch          |
| git hf help            | Print usage guide                             |

#### 💡 Example Usage

```bash
git hf feat git-aliases
# → Creates and checks out feat/git-aliases from updated main

# After testing and committing:
git hf done feat/git-aliases
# → Merges into main, deletes local and remote branch

```

This behaves similarly to git flow, but is simpler, portable, and customized for GitHub Flow.

### ⚙️ Alias Definition (git/config)

Stored in:

```plaintext
dotfiles/git/config

```

This file contains:

- hf alias definition with all subcommands
- core.autocrlf = input setting to normalize line endings

To enable it, make sure it's included in your personal ~/.gitconfig.

### 📌 Notes

- All GitHub Flow branches are short-lived and topic-specific.
- You are encouraged to:
  - Group related config + documentation changes in the same feature branch.
  - Keep main always deployable or ready-to-use.
  - Use git hf help to re-display available commands.

### 🔒 Compatibility

| Environment          | Works With                |
| -------------------- | ------------------------- |
| macOS / Linux        | ✅ Bash, Zsh, etc.        |
| Git Bash (Windows)   | ✅ Fully supported        |
| PowerShell (Windows) | ✅ With .ps1 setup script |
| WSL                  | ✅ Native                 |

### 🧼 Future Ideas

- Add auto-completion for git hf subcommands
- Build a docs/git-alias-cheatsheet.md
- Add logging to setup scripts for auditability
