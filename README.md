# nvim config

My neovim configuration.

## Requirement

- neovim (stable or nightly)
- [mason.nvim requirements](https://github.com/mason-org/mason.nvim?tab=readme-ov-file#requirements)
- [nvim-treesitter requirements](https://github.com/nvim-treesitter/nvim-treesitter/tree/main?tab=readme-ov-file#requirements)

## Installation

Run below command.

```
git clone https://github.com/pogyomo/nvim ~/.config/nvim
```

Then, create settings.json by copying from default_settings.json, or from scratch.

```
cd ~/.config/nvim
cp default_settings.json settings.json
# nvim settings.json
```

## Using with msys2

If you are using msys2, and neovim is installed using pacman,
it's recommended to install win32yank.exe so clipboard works well.

```bash
curl -LO https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip
unzip win32yank-x64.zip win32yank.exe -d $(dirname $(which nvim))
```

