{ config, pkgs, lib, root, ... }: with lib; let
  home = config.deploy.targets.home.tf;
in {
  options = {
      networks = let
        meta = config;
      in mkOption{
        type = with types; attrsOf (submodule ({ name, config, ... }: {
          options = {
            member_configs = mkOption {
            type = unspecified;
          };
            members = mkOption {
            type = unspecified;
          };
        };}));
      };
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

  networks = let
    names = [ "gensokyo" "chitei" "internet" "tailscale" ];
    network_filter = network: rec {
      member_configs = filterAttrs (_: nodeConfig: nodeConfig.networks.${network}.interfaces != []) config.network.nodes.nixos;
      members = mapAttrs (_: nodeConfig: nodeConfig.networks.${network}) member_configs;
    };
    networks' = genAttrs names network_filter;
  in networks';

  tailnet_uri = "inskip.me";
  tailnet = let
    raw = home.resources.tailnet_devices.importAttr "devices";
  in mkIf (home.state.enable) (mapListToAttrs (elet: nameValuePair (removeSuffix ".${config.tailnet_uri}" elet.name) {
      tags = elet.tags;
        ipv4 = head (filter (e: hasInfix "." e) elet.addresses);
        ipv6 = head (filter (e: hasInfix ":" e) elet.addresses);
      }) raw);

  runners = {
    lazy = {
      file = ./default.nix;
      args = [ "--show-trace" ];
    };
  };

  kw.secrets.command =
    let
      bitw = pkgs.writeShellScriptBin "bitw" ''${pkgs.rbw-bitw}/bin/bitw -p gpg://${config.network.nodes.all.${builtins.getEnv "HOME_HOSTNAME"}.kw.secrets.repo.bitw.source} "$@"'';
    in
    "${bitw}/bin/bitw get";

  deploy.targets.dummy.enable = false;
  deploy.targets.marisa.tf.terraform.refreshOnApply = false;
  _module.args.pkgs = lib.mkDefault pkgs;
};
}
