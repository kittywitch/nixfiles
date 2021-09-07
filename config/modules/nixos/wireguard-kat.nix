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

  network.wireguard = {
    publicAddress4 = mkDefault (if config.network.addresses.public.nixos.ipv4.enable then
      config.network.addresses.public.nixos.ipv4.address
      else if config.network.addresses.private.nixos.ipv4.enable then
      config.network.addresses.private.nixos.ipv4.address else null);
    publicAddress6 = mkDefault (if config.network.addresses.public.nixos.ipv6.enable then
      config.network.addresses.public.nixos.ipv6.address
      else if config.network.addresses.private.nixos.ipv6.enable then
      config.network.addresses.private.nixos.ipv6.address else null);
  };
}
