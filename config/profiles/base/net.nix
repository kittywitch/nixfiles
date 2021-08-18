{ config, lib, ... }:

{
  network.nftables.enable = lib.mkDefault true;
  network.enable = true;
  network.dns.enable = true;
}
