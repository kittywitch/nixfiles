{ config, lib, ... }:

with lib;

{
  kw.fw = {
    public.tcp.ports = [ 6600 32101 ];
    private.tcp.ports = [ 6600 32101 ];
  };
}
