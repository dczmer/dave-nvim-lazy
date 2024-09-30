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

Instead of installing this as a system package or installing it in my user profile, I've been just running it from this local flake:
`$> nix run /path/to/dave-nvim-lazy -- ...`
This way, I can quickly modify the config in another terminal and then just restart vim to pick it up.

# Notes on LSPs

The idea was to only install a few core LSP/linters in the base config, and any projects can make devshells and install the lsp/linter dependencies and neovim can just use them from the environment.

To do this, you need to make a dev shell for your project and install the required dependencies as `inputs`.

## Python

LSP: install `pkgs.pyright` in your devshell.

Linting: install python package `flake8`.

Formatting: install python packages `black` and `isort`.

Installing python packages:
- Option 1: pure-nix install using `pkgs.python3.withPackages ...`.
- Option 2: using `poetry` and `poetry2nix` to manage a `requirements.txt` file that can be used on non-nix systems.

## Javscript/Typescript

LSP: `typescript-language-server` can serve typescript and javascript files. Install node packages `typescript` and `typescript-language-server`.

Linting: Install node packages `eslint` and any config/plugins for your project.

Formating: Install node package `prettier`.

Installing node packages is kind of tricky still. You can use `yarn2nix` or `yarnConfigHook`/etc. to manage a `yarn` environment and install/manage packages.
