{ config, meta, lib, pkgs, ... }:

with lib;

let
  cfg = config.network.yggdrasil;
  calcAddr = pubkey: lib.readFile (pkgs.runCommandNoCC "calcaddr-${pubkey}" { } ''
    echo '{ SigningPublicKey: "${pubkey}" }' | ${config.services.yggdrasil.package}/bin/yggdrasil -useconf -address | tr -d '\n' > $out
  '').outPath;
in
{
  options.network.yggdrasil = {
    enable = mkEnableOption "Enable the yggdrasil-based private hexnet";
    pubkey = mkOption {
      type = types.str;
      description = "Public key of this node";
    };
    address = mkOption {
      type = types.str;
      #description = "Main Yggdrasil address. Set automatically";
      #default = calcAddr cfg.signingPubkey;
      default = "";
    };
    trust = mkOption {
      type = types.bool;
      description = "Open Firewall completely for the network";
      default = false;
    };
    listen = {
      enable = mkOption {
        type = types.bool;
        description = "Allow other hosts in the network to connect directly";
        default = false;
      };
      endpoints = mkOption {
        type = types.listOf types.str;
        description = "Endpoints to listen on";
        default = [ ];
      };
    };
    tunnel = {
      localV6 = mkOption {
        type = types.listOf types.str;
        description = "v6 subnets to expose";
        default = [ ];
      };
      localV4 = mkOption {
        type = types.listOf types.str;
        description = "v4 subnets to expose";
        default = [ ];
      };
      remoteV6 = mkOption {
        type = types.attrsOf types.str;
        description = "Extra v6 subnets to route";
        default = { };
      };
      remoteV4 = mkOption {
        type = types.attrsOf types.str;
        description = "Extra v4 subnets to route";
        default = { };
      };
    };
    extra = {
      pubkeys = mkOption {
        type = types.attrsOf types.str;
        description = "Additional hosts to allow into the network. Keys won't be added to definition host.";
        default = { };
        example = { host = "0000000000000000000000000000000000000000000000000000000000000000"; };
      };
      addresses = mkOption {
        type = types.attrsOf types.str;
        internal = true;
        default = mapAttrs (_: c: calcAddr c) cfg.extra.pubkeys;
      };
      localV6 = mkOption {
        type = types.listOf types.str;
        description = "v6 subnets to expose, but not route";
        default = [ ];
      };
      localV4 = mkOption {
        type = types.listOf types.str;
        description = "v4 subnets to expose, but not route";
        default = [ ];
      };
    };
    extern = {
      pubkeys = mkOption {
        type = types.attrsOf types.str;
        description = "Additional hosts to allow into the network. Keys won't be added to definition host.";
        default = { };
        example = { host = "0000000000000000000000000000000000000000000000000000000000000000"; };
      };
      endpoints = mkOption {
        type = types.listOf types.str;
        description = "Endpoints to listen on";
        default = [ ];
      };
    };
  };

  config = mkIf cfg.enable (
    let
      yggConfigs = filter
        (
          c: c.enable && (cfg.pubkey != c.pubkey)
        )
        (
          mapAttrsToList (_: node: node.network.yggdrasil or { enable = false; pubkey = null; }) meta.network.nodes.nixos
        );
      pubkeys = flatten ((filter (n: n != "0000000000000000000000000000000000000000000000000000000000000000") (attrValues cfg.extern.pubkeys)) ++ (map (c: [ c.pubkey ] ++ (attrValues c.extra.pubkeys)) yggConfigs));
    in
    {
      assertions = [
        {
          assertion = !(cfg.listen.enable && (cfg.listen.endpoints == [ ]));
          message = "Specify network.yggdrasil.listen.endpoints";
        }
      ];

      networking.firewall.trustedInterfaces = mkIf cfg.trust [ "yggdrasil" ];

      services.yggdrasil = {
        enable = true;
        persistentKeys = true;
        config = {
          AllowedPublicKeys = pubkeys;
          IfName = "yggdrasil";
          Listen = cfg.listen.endpoints;
          Peers = lib.flatten (cfg.extern.endpoints ++ (map (c: c.listen.endpoints) (filter (c: c.listen.enable) yggConfigs)));
        };
      };

      system.build.yggdrasilTemplate =
        let
          json = builtins.toJSON {
            inherit (config.services.yggdrasil.config) Peers SessionFirewall TunnelRouting;
            PublicKey = "";
            PrivateKey = "";
          };
        in
        pkgs.runCommandNoCC "yggdrasil-template.json" { }
          "echo '${json}' | ${config.services.yggdrasil.package}/bin/yggdrasil -useconf -normaliseconf > $out";
    }
  );
}
