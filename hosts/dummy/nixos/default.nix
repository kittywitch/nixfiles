{ config, lib, pkgs, sources, ... }:

with lib;

let
  hexchen = (import sources.nix-hexchen) {};
  hexYgg = filterAttrs (_: c: c.enable) (
    mapAttrs (_: host: host.config.hexchen.network) hexchen.hosts
  );
in {
  # stuff so dummy host is buildable (you probably don't want/need this???)
  # but idk your config sooooo
  boot.isContainer = true;
  networking.useDHCP = false;
  users.users.root.hashedPassword = "";

  hexchen.network = {
    enable = true;
    pubkey = "0000000000000000000000000000000000000000000000000000000000000000";
    listen.enable = true;
    listen.endpoints = flatten (map (c: c.listen.endpoints) (filter (c: c.listen.enable) (attrValues hexYgg)));
    extra.pubkeys = {
    } // (mapAttrs (_: c: c.pubkey) hexYgg);
  };

  # snippet for single host
  # hexchen.network = {
  #   enable = true;
  #   pubkey = "0000000000000000000000000000000000000000000000000000000000000000";
  #   # if server, enable this and set endpoint:
  #   listen.enable = false;
  #   listen.endpoints = [
  #     "tcp://0.0.0.0:0"
  #   ];
  # };
}
