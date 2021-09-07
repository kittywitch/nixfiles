{ config, lib, ... }: with lib;

{
  networking.nftables.enable = true;

  network = {
    enable = true;
    dns = {
      enable = mkDefault true;
      email = "acme@kittywit.ch";
      zone = "kittywit.ch.";
    };
  };
}
