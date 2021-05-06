{ config, lib, ... }:

{
  petabyte.nftables.enable = lib.mkDefault true;
}
