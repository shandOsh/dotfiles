# hologos' dotfiles

*Based on idea of [carlos' dotfiles](https://github.com/caarlos0/dotfiles).*

> Config files for ZSH, vim, git and more.

## Installation

### Dependencies

First, make sure you have all those things installed:

- `git`: to clone the repo
- `zsh`: to actually run the dotfiles

### Install

Then, run these steps:

```bash
git clone git@github.com:Hologos/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./installation/bootstrap
zsh # or just close and open your terminal again.
```

> All changed files will be backed up with a `.backup` suffix.

## Creating new module

To create new module, you have to create new directory in modules directory. Every module should contain an installation script called `install.sh`. All installation logic should be here. If nothing has to be done, it's good practice to at least inform the user about the module.

The installation script will be called automatically from the `installation/bootstrap` and every time `modules/bin/dot_update` is called.

These files will be loaded automatically by ZSH itself:

- `aliases.zsh` (set aliases here)
- `envvars.zsh` (set environmental variables here)
- `paths.zsh` (set PATH variable here)

Other files have to be managed by the installation script.

### Helper functions

These helper functions are available to you by default:

- success()
- fail()
- info()
- skipped()
- backup_file()
- link_file()
- os_detection()
- is_installed()
