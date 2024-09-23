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
