{ config, lib, ... }:

{
  network.nftables.enable = lib.mkDefault true;
}
