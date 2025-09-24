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
      pkgs.writeShellScriptBin package.pname ''
        ${getExe config.nix.package} run nixpkgs#${package.pname} -- "$@"
      '';
  in
    map aliaser packages;
}
