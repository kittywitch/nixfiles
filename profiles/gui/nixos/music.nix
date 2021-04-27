{ config, lib, ... }:

with lib;

{
  katnet.private.tcp.ports = singleton 32101;
}
