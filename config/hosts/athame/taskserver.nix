{ config, lib, ... }:

{
  services.taskserver.enable = true;
  services.taskserver.fqdn = "kittywit.ch";
  services.taskserver.listenHost = "::";
  services.taskserver.organisations.kittywitch.users = [ "kat" ];
}
