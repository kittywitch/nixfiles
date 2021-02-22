{ config, pkgs, ... }:

let
  sources = import ../../../../nix/sources.nix;
  unstable = import sources.nixpkgs-unstable { inherit (pkgs) config; };
in {
  services.weechat = {
    binary = let
      new-weechat = pkgs.arc.pkgs.wrapWeechat pkgs.arc.pkgs.weechat-unwrapped {
        configure = { availablePlugins, ... }: {
          scripts = [ pkgs.arc.pkgs.weechatScripts.weechat-matrix ];
          plugins = [
            availablePlugins.perl
            (availablePlugins.python.withPackages
              (ps: [ ps.potr ps.weechat-matrix ]))
          ];
        };
      };
    in "${new-weechat}/bin/weechat";
    enable = true;
  };

  programs.screen.screenrc = ''
    multiuser on
    acladd kat
  '';
}
