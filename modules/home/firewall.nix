{ config, lib, pkgs, ... }:

with lib;

let cfg = config.network.firewall;
in
{
  options.network.firewall = {
    public.tcp.ports = mkOption {
      type = types.listOf types.port;
      default = [ ];
    };
    public.udp.ports = mkOption {
      type = types.listOf types.port;
      default = [ ];
    };
    private.tcp.ports = mkOption {
      type = types.listOf types.port;
      default = [ ];
    };
    private.udp.ports = mkOption {
      type = types.listOf types.port;
      default = [ ];
    };

    public.tcp.ranges = mkOption {
      type = types.listOf (types.attrsOf types.port);
      default = [ ];
    };
    public.udp.ranges = mkOption {
      type = types.listOf (types.attrsOf types.port);
      default = [ ];
    };
    private.tcp.ranges = mkOption {
      type = types.listOf (types.attrsOf types.port);
      default = [ ];
    };
    private.udp.ranges = mkOption {
      type = types.listOf (types.attrsOf types.port);
      default = [ ];
    };

    public.interfaces = mkOption {
      type = types.listOf types.str;
      description = "Public firewall interfaces";
      default = [ ];
    };
    private.interfaces = mkOption {
      type = types.listOf types.str;
      description = "Private firewall interfaces";
      default = [ ];
    };
  };
}
