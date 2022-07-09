{ config, lib, pkgs, ... }:

with lib;

let
  bcfg = config.network.bird;
  cfg = config.network.bird.ospf;
in
{
  options.network.bird = {
    routerId = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Router ID to use. Must be an IPv4 address.";
    };
    kernel4Config = mkOption {
      type = types.lines;
      default = ''
        ipv4 {
          import none;
          export filter {
            if source = RTS_STATIC then reject;
            accept;
          };
        };
        scan time 15;
      '';
    };
    kernel6Config = mkOption {
      type = types.lines;
      default = ''
        ipv6 {
          import none;
          export filter {
            if source = RTS_STATIC then reject;
            accept;
          };
        };
        scan time 15;
      '';
    };
    staticRoutes4 = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    extraStatic4 = mkOption {
      type = types.lines;
      default = "";
    };
    staticRoutes6 = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
    extraStatic6 = mkOption {
      type = types.lines;
      default = "";
    };
  };
  options.network.bird.ospf = {
    enable = mkEnableOption "OSPF-based network routing";
    protocols = mkOption {
      default = { };
      type = types.attrsOf (types.submodule {
        options = {
          version = mkOption { type = types.enum [ 2 3 ]; default = 2; };
          extra = mkOption { type = types.lines; default = ""; };
          areas = mkOption {
            description = "areas to configure in bird";
            default = { };
            type = types.attrsOf (types.submodule {
              options = {
                extra = mkOption { type = types.lines; default = ""; };
                networks = mkOption {
                  description = "Definition of area IP ranges. This is used in summary LSA origination.";
                  type = types.listOf types.str;
                  default = [ ];
                };
                external = mkOption {
                  description = "Definition of external area IP ranges for NSSAs. This is used for NSSA-LSA translation.";
                  type = types.listOf types.str;
                  default = [ ];
                };
                interfaces = mkOption {
                  description = "Interfaces to assign to the area";
                  type = types.attrsOf (types.submodule {
                    options = {
                      cost = mkOption { type = types.int; default = 10; };
                      poll = mkOption { type = types.int; default = 20; };
                      retransmit = mkOption { type = types.int; default = 5; };
                      priority = mkOption { type = types.int; default = 1; };
                      deadCount = mkOption { type = types.int; default = 4; };
                      type = mkOption {
                        type = types.enum [
                          null
                          "broadcast"
                          "bcast"
                          "pointopoint"
                          "ptp"
                          "nonbroadcast"
                          "nbma"
                          "pointomultipoint"
                          "ptmp"
                        ];
                        default = null;
                      };
                      extra = mkOption { type = types.lines; default = ""; };
                    };
                  });
                };
              };
            });
          };
        };
      });
    };
  };

  config = mkIf cfg.enable {
    services.bird2 = {
      enable = true;
      config = ''
        ${optionalString (bcfg.routerId != null) "router id ${bcfg.routerId};"}

        protocol device {
          scan time 10;
        }

        protocol kernel kernel4 {
          ${bcfg.kernel4Config}
        }
        protocol kernel kernel6 {
          ${bcfg.kernel6Config}
        }

        protocol static static4 {
          ipv4 { import all; export none; };
          ${concatMapStringsSep "\n" (x: "route ${x};") bcfg.staticRoutes4}
          ${bcfg.extraStatic4}
        }
        protocol static static6 {
          ipv6 { import all; export none; };
          ${concatMapStringsSep "\n" (x: "route ${x};") bcfg.staticRoutes6}
          ${bcfg.extraStatic6}
        }

        ${concatStringsSep "\n" (mapAttrsToList (protoName: proto: ''
            protocol ospf v${toString proto.version} ${protoName} {
              ${concatStringsSep "\n" (mapAttrsToList (areaName: area: ''
                  area ${areaName} {
                    ${optionalString
                      (area.networks != [])
                      "networks { ${concatStringsSep "\n" (map (x: "${x};") area.networks)} };"}
                    ${optionalString
                      (area.external != [])
                      "external { ${concatStringsSep "\n" (map (x: "${x};") area.external)} };"}
                    ${concatStringsSep "\n" (mapAttrsToList (ifacePattern: iface: ''
                      interface "${ifacePattern}" {
                        cost ${toString iface.cost};
                        poll ${toString iface.poll};
                        retransmit ${toString iface.retransmit};
                        priority ${toString iface.priority};
                        dead count ${toString iface.deadCount};
                        ${optionalString (iface.type != null) "type ${iface.type};"}
                        ${iface.extra}
                      };
                    '') area.interfaces)}
                    ${area.extra}
                  };
                '') proto.areas)}
              ${proto.extra}
            }
          '') cfg.protocols)}
      '';
    };
  };
}
