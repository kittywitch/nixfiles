{ config, pkgs, lib, root, ... }: with lib; let
  home = config.deploy.targets.home.tf;
in {
  options = {
    tailnet_uri = mkOption {
      type = types.str;
    };
    tailnet = mkOption {
      type = types.attrsOf (types.submodule ({ name, config, ... }: {
        options = {
          ipv4 = mkOption {
            type = types.str;
          };
          ipv6 = mkOption {
            type = types.str;
          };
          id = mkOption {
            type = types.str;
          };
          user = mkOption {
            type = types.str;
          };
          pp = mkOption {
            type = types.unspecified;
            default = family: port: "http://${config."ipv${toString family}"}:${toString port}/";
          };
          ppp = mkOption {
            type = types.unspecified;
            default = family: port: path: "http://${config."ipv${toString family}"}:${toString port}/${path}";
          };
          tags = mkOption {
            type = types.listOf types.str;
          };
        };
      }));
    };
  };
  config = {
    tailnet_uri = "inskip.me";
    tailnet = let
      raw = home.resources.tailnet_devices.importAttr "devices";
    in mkIf (home.state.enable) (mapListToAttrs (elet: nameValuePair (removeSuffix ".${config.tailnet_uri}" elet.name) {
        tags = elet.tags;
        id = elet.id;
        user = elet.user;
          ipv4 = head (filter (e: hasInfix "." e) elet.addresses);
          ipv6 = head (filter (e: hasInfix ":" e) elet.addresses);
        }) raw);
  };
}
