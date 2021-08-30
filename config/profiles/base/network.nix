{ config, lib, ... }:

{
  network = {
    enable = true;
    nftables.enable = true;
    dns = {
      enable = true;
      email = "acme@kittywit.ch";
      tld = "kittywit.ch.";
    };
  };
}
