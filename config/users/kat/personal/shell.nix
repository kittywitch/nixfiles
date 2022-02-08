{ config, lib, pkgs, ... }: with lib;

{
  home.shell.functions = {
    nano = ''
      ${pkgs.kitty}/bin/kitty +kitten icat ${./nano.png}
    '';
  };
  home.packages = map (attr: pkgs.writeShellScriptBin "abby${attr}" "mpv $(bitw get secrets/abby -f ${attr})") [ "radio" "tv" ];
}
