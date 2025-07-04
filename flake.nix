{
  description = "Neovim with LSP and lazy-loading";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        customRC = import ./config { inherit pkgs; };
        neovimWrapped = pkgs.wrapNeovim pkgs.neovim-unwrapped {
          configure = {
            inherit customRC;
            packages.myVimPackage = with pkgs.vimPlugins; {
              start = [
                lz-n

                # these either need to be installed at start, or just provide
                # lua libraries for other plugins and don't affect startup time.
                # treesitter can be lazy loaded, and seems to work, but gives checkhealth errors.
                nvim-treesitter.withAllGrammars
                nvim-treesitter-textobjects
                nvim-treesitter-parsers.fsharp
                playground
                nvim-web-devicons
                telescope-fzf-native-nvim
                nvim-lspconfig
                nvim-cmp
                cmp-buffer
                cmp-path
                cmp-nvim-lsp
                cmp-nvim-lsp-signature-help
                lspkind-nvim
                luasnip
                cmp_luasnip
                friendly-snippets
                plenary-nvim
                vim-nix
                camelcasemotion
                cyberdream-nvim
                nvim-dap-python
                vim-sleuth
              ];
              opt = [
                gitsigns-nvim
                neo-tree-nvim
                vim-startuptime
                rainbow-delimiters-nvim
                telescope-nvim
                nvim-lint
                conform-nvim
                nvim-surround
                fugitive
                vim-markdown
                markdown-preview-nvim
                vim-tmux-navigator
                vim-suda
                luvit-meta
                lazydev-nvim
                lualine-nvim
                bufferline-nvim
                nvim-dap
                nvim-colorizer-lua
                undotree
              ];
            };
          };
        };
        app = pkgs.writeShellApplication {
          name = "nvim";
          text = ''
            exec ${neovimWrapped}/bin/nvim "$@"
          '';
          runtimeInputs =
            with pkgs;
            [
              # telescope and treesitter dependencies
              ripgrep
              fd
              fzf
              powerline-fonts
              gcc

              # always install lua and nix lsp
              nixd
              lua-language-server
              lua54Packages.luacheck
              shellcheck
              stylua
              nixfmt-rfc-style
              yamlfix
              yamllint
            ]
            ++ vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
        };
      in
      {
        packages = {
          default = app;
        };
        apps = {
          default = {
            type = "app";
            program = "${app}/bin/nvim";
          };
        };
      }
    );
}
