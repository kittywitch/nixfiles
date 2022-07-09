{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.network.firewall;
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

  config = {
    network.firewall = mkMerge (mapAttrsToList (_: user: user.network.firewall) config.home-manager.users);
    networking.firewall.interfaces =
      let
        fwTypes = {
          ports = "Ports";
          ranges = "PortRanges";
        };

        interfaceDef = visibility:
          listToAttrs (flatten (mapAttrsToList
            (type: typeString:
              map
                (proto: {
                  name = "allowed${toUpper proto}${typeString}";
                  value = cfg.${visibility}.${proto}.${type};
                }) [ "tcp" "udp" ])
            fwTypes));

        interfaces = visibility:
          listToAttrs
            (map (interface: nameValuePair interface (interfaceDef visibility))
              cfg.${visibility}.interfaces);
      in
      mkMerge (map (visibility: interfaces visibility) [ "public" "private" ]);
  };
}
