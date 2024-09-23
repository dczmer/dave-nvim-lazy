# My Neovim + LSP + Treesitter flake for Nix

My general-purpose vim flake.

Uses lazy loading for most things, but I'm not trying to make startup time instant, just to not load the world for every language/LSP when they are not needed.
Some things had to happen at startup, like `cmp` and `treesitter`.

Leveraging nvim's treesitter API via `nvim-treesitter` and a few plugins to provide a `playground` and TS node-based textobject definitions.

Also leveraging nvim's native LSP functionality to replace `coc`.

The colorscheme was chosen for dark terminal with transparency.

The lazy-loader config file is the new entry point for defining your configuration, and plugin-specific config modules make more sense than global `keys.vim`, `settings.vim`, etc.
I've started using a pattern of making lua modules for each plugin, and exposing a `lazy()` method that returns the plugin spec for the lazy-loader directly.
This lets me decompose the settings into local variables and functions and reduce the amount of nesting.

I'm using the official `nixpkgs` version of neovim. It's easy to change the `neovim-unwrapped` package in the flake to use the nightly version from github, but my treesitter config had errors on that build.

I've included LSP+linter support for shell scripts, lua, and nix with the base load-out.
I'm expecting that anything language-specific (pyright, ts-server, etc.) can be installed in a devenv and the lazy-loader will detect the file type, load the LSP, and it should just work.
