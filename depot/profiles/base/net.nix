{ config, lib, ... }:

{
  kw.nftables.enable = lib.mkDefault true;
}
