{ config, lib, ... }:

with lib;

{
  katnet.private.tcp.ports = [ 6600 32101 ];
}
