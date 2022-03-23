{ config, pkgs, lib, tf, ... }: with lib; let
  inherit (tf.lib.tf) terraformSelf;
  cfg = config.network.wireguard;
  dataDir = toString tf.terraform.dataDir;
in {
  options.network.wireguard.tf = {
    enable = mkEnableOption "using terraform for wireguard module";
  };
  config = mkIf config.network.wireguard.tf.enable {
    deploy.tf = {
      resources = {
        "${config.networking.hostName}-wgmesh-gen" = {
          provider = "null";
          type = "resource";
          provisioners = singleton {
            local-exec.command = let
              wg = "${pkgs.buildPackages.wireguard-tools}/bin/wg";
            in "${wg} genkey | tee ${dataDir + "/wg-private-${terraformSelf "id"}"} | ${wg} pubkey > ${dataDir + "/wg-public-${terraformSelf "id"}"}";
          };
        };
        "${config.networking.hostName}-wgmesh-public-key" = {
          provider = "local";
          type = "file";
          dataSource = true;
          inputs.filename = dataDir + "/wg-public-${tf.resources."${config.networking.hostName}-wgmesh-gen".refAttr "id"}";
        };
      };
      deploy.systems.${config.networking.hostName}.triggers.switch = {
        wg = tf.resources."${config.networking.hostName}-wgmesh-public-key".refAttr "content";
      };
    };

    secrets.files."${config.networking.hostName}-wgmesh-private-key" = rec {
      source = dataDir + "/wg-private-${tf.resources."${config.networking.hostName}-wgmesh-gen".refAttr "id"}";
      text = source;
    };

    network.wireguard = {
      magicNumber = mkDefault (hexToInt (substring 0 2 (builtins.hashString "sha256" config.networking.hostName)));
      keyPath = config.secrets.files."${config.networking.hostName}-wgmesh-private-key".path;
      pubkey = let
        pubKeyRes = tf.resources."${config.networking.hostName}-wgmesh-public-key";
      in mkIf (tf.state.resources ? ${pubKeyRes.out.reference}) (removeSuffix "\n" (pubKeyRes.importAttr "content"));
    };
  };
}
