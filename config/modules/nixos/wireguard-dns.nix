{ config, lib, ... }: with lib; let
  cfg = config.network;
  wgcfg = config.network.wireguard;
  magic = toString wgcfg.magicNumber;
in {
  network.addresses.wireguard = {
    enable = config.network.wireguard.enable;
    nixos = {
      ipv4.address = "${wgcfg.prefixV4}.${magic}";
      ipv6.address = "${wgcfg.prefixV6}:${magic}";
    };
    prefix = "wg";
    subdomain = "${config.networking.hostName}.${cfg.addresses.wireguard.prefix}";
  };
}
