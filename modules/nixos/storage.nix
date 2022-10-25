{ config, lib, pkgs, meta, tf, ... }: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.modules) mkIf mkMerge;
  inherit (lib.attrsets) mapAttrs filterAttrs mapAttrsToList attrValues;
  inherit (lib.lists) concatLists;
  inherit (lib.types) attrsOf listOf str;
  cfg = config.storage;
  in {
  options.storage = {
    enable = mkEnableOption "nixfiles storage primitives";
    replica = mkEnableOption "full replication of our volumes onto a node";
    defaultBrick = mkEnableOption "naively create a default brick for this node";
    bricks = mkOption {
      type = attrsOf str;
      default = if cfg.defaultBrick then {
        default = "/export/default/brick";
      } else {};
      description = "the brick locations used by glusterfs";
    };
    replicas = mkOption {
      type = listOf str;
      default = let
        replicaNodes = filterAttrs (_: node: node.storage.replica) config.network.nodes.nixos;
      in concatLists (mapAttrsToList (_: node: map (brick: "${node.networks.tailscale.uqdn}:${brick}" (attrValues node.storage.bricks)) replicaNodes));
    };
    services = mkOption {
      type = listOf str;
      default = let
        filteredServices = removeAttrs config.services [
          "chronos" "beegfs" "beegfsEnable" "bird"
          "bird6" "bitwarden_rs" "buildkite-agent" "cgmanager"
          "codimd" "couchpotato" "cryptpad" "dd-agent"
          "deepin" "dnscrypt-proxy" "flashpolicyd" "dhcpd"
          "foldingAtHome" "fourStore" "fourStoreEndpoint" "fprot"
          "frab" "geoip-updater" "gogoclient" "hbase"
          "iodined" "kippo" "localtime" "mailpile"
          "marathon" "mathics" "meguca" "mesos"
          "mingetty" "moinmoin" "mwlib" "nixosManual"
          "openfire" "openvpn" "osquery" "paperless-ng"
          "piwik" "plexpy" "prey" "prometheus2"
          "quagga" "racoon" "railcar" "redis"
          "riak" "rmilter" "seeks" "shellinabox"
          "ssmtp" "venus" "virtuoso" "vmwareGuest"
          "wakeonlan" "winstone" "nginx"
        ];
        #enabledServices = filterAttrs (_: settings: (settings ? enable) && settings.enable) filteredServices;
        enabledServices = filterAttrs (_: service: service ? serviceConfig.RuntimeDirectory) config.systemd.services;
        serviceDirs = mapAttrsToList (service: _: service) enabledServices;
      in serviceDirs;
    };
  };
  config = mkMerge [
    (mkIf false {
      environment.systemPackages = [ pkgs.glusterfs ];

      services.glusterfs = {
        enable = true;
        tlsSettings = {
          tlsKeyPath = config.networks.tailscale.key_path;
          tlsPem = config.networks.tailscale.cert_path;
        };
      };

      deploy.tf = {
      };
    })
    (mkIf cfg.defaultBrick {
      system.activationScripts.nixfiles-storage-defaultbrick.text = ''
        mkdir -p /export/default/brick
      '';
    })
    (mkIf cfg.replica {
      deploy.tf = {
      };
    })
  ];
}
