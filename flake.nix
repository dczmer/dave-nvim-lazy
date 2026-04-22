{
  description = "Neovim with LSP and lazy-loading";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    davewiki2 = {
      url = "github:dczmer/davewiki2";
      flake = false;
    };
  };
  outputs =
    {
      nixpkgs,
      flake-utils,
      davewiki2,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        davewiki2Plugin = pkgs.vimUtils.buildVimPlugin {
          pname = "davewiki2";
          version = "unstable";
          src = davewiki2;
        };
        customRC = import ./config { inherit pkgs; };
        runtimeInputs = with pkgs; [
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
          nixfmt
          yamlfix
          yamllint
          vimwiki-markdown
          universal-ctags
          pandoc

          (python3.withPackages (
            p: with p; [
              tasklib
              pynvim
            ]
          ))

          lsof
        ];
        neovimWrapped = pkgs.wrapNeovim pkgs.neovim-unwrapped {
          configure = {
            inherit customRC;
            packages.myVimPackage = with pkgs.vimPlugins; {
              start = [
                lz-n

                # these either need to be installed at start, or just provide
                # lua libraries for other plugins and don't affect startup time.
                # treesitter can be lazy loaded, and seems to work, but gives checkhealth errors.
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
                vim-snippets
                plenary-nvim
                vim-nix
                camelcasemotion
                cyberdream-nvim
                vim-sleuth
              ];
              opt = [
                davewiki2Plugin
                gitsigns-nvim
                neo-tree-nvim
                vim-startuptime
                rainbow-delimiters-nvim
                telescope-nvim
                nvim-lint
                conform-nvim
                nvim-surround
                vim-fugitive
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
                tagbar
                vim-table-mode
                mattn-calendar-vim
                bullets-vim
                vim-closetag
                which-key-nvim
                snacks-nvim
                opencode-nvim
                claudecode-nvim
                mini-test
              ];
            };
          };
        };
        app = pkgs.writeShellApplication {
          name = "nvim";
          text = ''
            exec ${neovimWrapped}/bin/nvim "$@"
          '';
          inherit runtimeInputs;
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
        devShells = {
          default = pkgs.mkShell {
            packages =
              with pkgs;
              [
                opencode
              ]
              ++ runtimeInputs;
            shellHook = ''
              # enable opencode extra tools for this shell
              export OPENCODE_ENABLE_EXA=1
              #exec zsh
            '';
          };
        };
      }
    );
}
