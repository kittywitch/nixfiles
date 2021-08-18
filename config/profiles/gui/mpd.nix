{ config, lib, ... }:

with lib;

{
  network.firewall = {
    public.tcp.ports = [ 6600 32101 ];
    private.tcp.ports = [ 6600 32101 ];
  };
}
