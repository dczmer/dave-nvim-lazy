# Copies the config files from this repository into the nix store, then
# returns a string that will be the contents of the neovim rc file.
# This file will just source the init.lua file from it's home in the nix store.
{ pkgs }:
let
  configDir = pkgs.stdenv.mkDerivation {
    name = "nvim-lua-lazy-poc-configs";
    src = ./lua; # NOTE: the installPhase commands relative to this dir
    installPhase = ''
      mkdir -p $out/lua
      cp ./init.lua $out/
      cp -r ./dave-vim $out/lua/
    '';
  };
in
''
  set rtp+=${configDir}
  source ${configDir}/init.lua
''
