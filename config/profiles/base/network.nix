{ config, lib, ... }:

{
  network = {
    enable = true;
    nftables.enable = true;
    dns = {
      enable = true;
      email = "kat@kittywit.ch";
      tld = "kittywit.ch.";
    };
  };
}
