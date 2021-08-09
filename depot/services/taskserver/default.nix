{ config, lib, ... }:

with lib;

{
  kw.fw.public.tcp.ports = singleton 53589;

  services.taskserver = {
    enable = true;
    fqdn = "kittywit.ch";
    listenHost = "::";
    organisations.kittywitch.users = singleton "kat";
  };
}
