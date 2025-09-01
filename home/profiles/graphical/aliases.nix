{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib.meta) getExe;
in {
  home.packages = let
    packages = with pkgs; [
      ungoogled-chromium
      sidequest
    ];
    aliaser = package:
      pkgs.writeShellScriptBin package.name ''
        ${getExe config.nix.package} run nixpkgs#${package.name} -- "$@"
      '';
  in
    map aliaser packages;
}
