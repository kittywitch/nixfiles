{ config, lib, ... }:

with lib;

{
  network.firewall.public.tcp.ports = singleton 53589;

  services.taskserver = {
    enable = true;
    fqdn = "kittywit.ch";
    listenHost = "::";
    organisations.kittywitch.users = singleton "kat";
  };
}
