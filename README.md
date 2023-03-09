# floating-input.nvim
Super simple Neovim floating input.

![screenshot](https://user-images.githubusercontent.com/1334962/219470205-7412c323-abd0-4074-9c61-da9a45432d47.jpg)

## Why

You use Telescope or Fzf-Lua to get a nice `vim.ui.select`, and want a nice `vim.ui.input` (e.g.
handling LSP rename) too?

[Dressing](https://github.com/stevearc/dressing.nvim) works, but most of its code deals with
`vim.ui.select`, which seems slightly overkill here.

This plugin is the simplest floating window to take input.

## How

Note this plugin uses a new [parameter](https://github.com/neovim/neovim/pull/20184),
which requires neovim nightly build or the upcoming 0.9 release.

Add `liangxianzhe/floating-input` to your plugin manager. Then `require('floating-input').setup()`.

Default is to put floating window under the cursor for LSP renaming, and at the center for other use cases. 

You can also config styles, or override other window configs: 
```lua
vim.ui.input = function(opts, on_confirm)
	require("floating-input").input(opts, on_confirm, { border = 'none' })
end
```
