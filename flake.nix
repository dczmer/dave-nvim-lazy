{
  description = "Neovim with LSP and lazy-loading";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ ];
      };
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
              playground
              nvim-web-devicons
              telescope-fzf-native-nvim
              nvim-lspconfig
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
            ];
            opt = [
              neo-tree-nvim
              vim-startuptime
              rainbow-delimiters-nvim
              telescope-nvim
              nvim-cmp
              nvim-lint
              conform-nvim
              nvim-surround
              fugitive
              vim-markdown
              vim-tmux-navigator
              vim-suda
              luvit-meta
              lazydev-nvim
              lualine-nvim
              bufferline-nvim
            ];
          };
        };
      };
      app = pkgs.writeShellApplication {
        name = "nvim";
        text = ''
          ${neovimWrapped}/bin/nvim "$@"
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
          ]
          ++ vimPlugins.nvim-treesitter.withAllGrammars.dependencies;
      };
    in
    {
      packages.x86_64-linux.default = app;
      apps.x86_64-linux.default = {
        type = "app";
        program = "${app}/bin/nvim";
      };
    };
}
