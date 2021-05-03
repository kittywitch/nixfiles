{ config, lib, pkgs, sources, ... }:

with lib;

let
  hexchen = (import sources.nix-hexchen) { };
  hexYgg = filterAttrs (_: c: c.enable)
    (mapAttrs (_: host: host.config.hexchen.network) hexchen.hosts);
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
    listen.endpoints = flatten (map (c: c.listen.endpoints) (filter (c:
      c.listen.enable && (c.pubkey
        != "0000000000000000000000000000000000000000000000000000000000000000"))
      (attrValues hexYgg)));
    extra.pubkeys = {
      satorin =
        "53d99a74a648ff7bd5bc9ba68ef4f472fb4fb8b2e26dfecea33c781f0d5c9525";
      shanghai =
        "0cc3c26366cbfddfb1534b25c5655733d8f429edc941bcce674c46566fc87027";
      grimoire =
        "2a1567a2848540070328c9e938c58d40f2b1a3f08982c15c7edc5dcabfde3330";
      boline = 
        "89684441745467da0d1bf7f47dc74ec3ca65e05c72f752298ef3c22a22024d43";
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
