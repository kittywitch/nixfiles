{ config, lib, ... }: with lib;

{
  networking.nftables.enable = true;
}
