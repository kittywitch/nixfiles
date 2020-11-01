let
  hosts = {
    yule = {
      ssh.host = "kat@yule";
      groups = [ "desktop" "personal" ];
    };
    beltane = {
      ssh.host = "kat@beltane";
      groups = [ "server" "personal" ];
    };
    samhain = {
      ssh.host = "kat@samhain";
      groups = [ "desktop" "personal" ];
    };
  };
  pkgs = import <nixpkgs> {};
  evalConfig = import <nixpkgs/nixos/lib/eval-config.nix>;
  lib = pkgs.lib;
in lib.mapAttrs (name: host: host // {
  config = if (host ? config) then host.config else (evalConfig {
    modules = [
      (import "${toString ./.}/${name}/configuration.nix")
    ];
  }).config;
}) hosts
