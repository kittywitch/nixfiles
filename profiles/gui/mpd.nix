{ config, lib, ... }:

with lib;

{
  kw.fw.private.tcp.ports = [ 6600 32101 ];
  kw.fw.public.tcp.ports = [ 6600 32101 ];
}
