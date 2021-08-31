{ config, lib, ... }: with lib;

{
  network = {
    enable = true;
    nftables.enable = true;
    dns = {
      enable = mkDefault true;
      email = "acme@kittywit.ch";
      tld = "kittywit.ch.";
    };
  };
}
