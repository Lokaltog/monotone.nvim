# m o n o t o n e

Another monochrome vim colorscheme. Inspired by various
[other](https://github.com/ewilazarus/preto)
[monochrome](https://github.com/pbrisbin/vim-colors-off)
[colorschemes](https://github.com/fxn/vim-monochrome).

Monotone is a middle ground between a regular colorscheme and [no syntax
highlighting at all](https://www.kyleisom.net/blog/2012/10/17/syntax-off/). The
colorscheme differentiates comments, strings and keywords with different
weights and shades of gray. It emphasizes errors, warnings and search
highlighting as shown in the screenshots below.

This is a neovim-specific version of
[vim-monotone](https://github.com/Lokaltog/vim-monotone) based on
[lush.nvim](https://github.com/rktjmp/lush.nvim). This version includes full
support for both dark and light `background`.

## Installation

Monotone depends on [lush.nvim](https://github.com/rktjmp/lush.nvim). Example using packer.nvim:

```
require('packer').startup(function()
  -- ...
  use 'rktjmp/lush.nvim'
  use 'Lokaltog/monotone.nvim'
  -- ...
end)

api.nvim_command 'colorscheme monotone'
```

## Customization

The theme color may be customized by setting HSL values with
`g:monotone_[hsl]`.

You may adjust the colorscheme contrast to your liking by setting
`g:monotone_contrast`.

The default contrast factor is 105. Recommended values are between 90 and 110.

## Configuration example

```
vim.g.monotone_h = 85
vim.g.monotone_s = 30
vim.g.monotone_l = 50
vim.g.monotone_contrast = 110
vim.g.monotone_true_monotone = true
vim.o.background = 'light'
```
