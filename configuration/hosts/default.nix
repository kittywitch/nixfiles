let
  hosts = {
    yule = {
      ssh.host = "kat@yule";
      groups = [ "laptop" "personal" "graphical" ];
    };
    beltane = {
      ssh.host = "kat@beltane";
      groups = [ "server" "personal" ];
    };
    samhain = {
      ssh.host = "kat@samhain";
      groups = [ "desktop" "personal" "graphical" ];
    };
    litha = {
      ssh.host = "root@litha";
      groups = [ "laptop" "personal" "graphical" ];
    };
    mabon = {
      ssh.host = "root@192.168.1.218";
      groups = [ "laptop" "personal" "graphical" ];
    };
  };
  pkgs = import <nixpkgs> { };
  evalConfig = import <nixpkgs/nixos/lib/eval-config.nix>;
  lib = pkgs.lib;
in lib.mapAttrs (name: host:
  host // {
    config = if (host ? config) then
      host.config
    else
      (evalConfig {
        modules = [ (import "${toString ./.}/${name}/configuration.nix") ];
      }).config;
  }) hosts
