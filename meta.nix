{ config, pkgs, lib, root, ... }: with lib; let
  home = config.deploy.targets.home.tf;
in {
  options = {
      tailnet_uri = mkOption {
        type = types.str;
      };
      tailnet = mkOption {
          type = types.attrsOf (types.submodule ({ name, ... }: {
            options = {
              addresses = {
                ipv4 = mkOption {
                  type = types.str;
                };
                ipv6 = mkOption {
                  type = types.str;
                };
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
    devices = mapListToAttrs (elet: nameValuePair (removeSuffix ".${config.tailnet_uri}" elet.name) {
      tags = elet.tags;
      addresses = let
        addresses = elet.addresses;
        ipv4 = head (filter (e: hasInfix "." e) addresses);
        ipv6 = head (filter (e: hasInfix ":" e) addresses);
      in {
        inherit ipv4 ipv6;
      };
      }) raw;
  in devices;

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
  _module.args.pkgs = lib.mkDefault pkgs;
};
}
