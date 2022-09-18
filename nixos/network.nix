{ config, lib, tf, pkgs, meta, ... }: with lib; {
  options = let
    nixos = config;
  in {
    domains = mkOption {
      default = {};
      type = with types; attrsOf (submodule ({ name, config, ... }: {
        options = {
          host = mkOption {
            type = nullOr str;
            default = nixos.networking.hostName;
          };
          network = mkOption {
            type = nullOr str;
            default = "internet";
          };
          type = mkOption {
            type = types.enum [
              "ipv4"
              "ipv6"
              "both"
              "cname"
            ];
          };
          domain = mkOption {
            type = nullOr str;
            default = "${nixos.networking.hostName}${if config.prefix != null then ".${config.prefix}" else ""}";
          };
          dn = mkOption {
            type = nullOr str;
            default = lib.removeSuffix "." config.domain;
          };
          prefix = mkOption {
            type = nullOr str;
            default = null;
          };
          zone = mkOption {
            type = nullOr str;
            default = "kittywit.ch.";
          };
          target = mkOption {
            type = nullOr str;
            default = if (config.type == "cname" && config.host != nixos.networking.hostName) then
              meta.network.nodes.nixos.${config.host}.networks.${config.network}.target
            else "${config.domain}.${config.zone}";
          };
        };
      }));
    };
    networks = let
      nixos = config;
    in mkOption {
      default = { };
      type = with types; attrsOf (submodule ({ name, config, options, ... }: let
        portRangeModule = { config, ... }: {
          options = {
            from = mkOption {
              type = types.port;
            };
            to = mkOption {
              type = types.port;
              default = config.from;
            };
            /*isRange = mkOption {
              type = types.bool;
              default = assert config.to >= config.from; config.from != config.to;
              readOnly = true;
            };*/
          };
        };
        portRangeType = types.submodule portRangeModule;
        convToPort = value: if isInt value
          then { from = value; }
          else assert length value == 2; { from = elemAt value 0; to = elemAt value 1; };
        portType = coercedTo (oneOf [ int (listOf int) ]) convToPort portRangeType;
      in {
        options = with types; {
          interfaces = mkOption {
            description = "Interfaces this network operates upon.";
            type = listOf str;
            default = [];
          };
          tcp = mkOption {
            description = "Port numbers or ranges to allow TCP traffic outbound.";
            type = listOf portType;
            default = [];
          };
          udp = mkOption {
            description = "Port numbers or ranges to allow UDP traffic outbound.";
            type = listOf portType;
            default = [];
          };
          ip = mkOption {
            description = "The machine's IPv4 address on the network, if it has one.";
            type = unspecified;
            default = hostname: class: if hostname != nixos.networking.hostName then
              if class == 6 then
                config.ipv6
              else if class == 4 then
                config.ipv4
                else throw "${nixos.networking.hostName}: IP for ${hostname} of ${class} is invalid."
            else
              if class == 6 then
                config.ipv6
              else if class == 4 then
                config.ipv4
                else throw "${nixos.networking.hostName}: IP for ${hostname} of ${class} is invalid.";
          };
          ipv4 = mkOption {
            description = "The machine's IPv4 address on the network, if it has one.";
            type = nullOr str;
          };
          ipv6 = mkOption {
            description = "The machine's IPv6 address on the network, if it has one.";
            type = nullOr str;
          };
          ipv4_defined = mkOption {
            type = types.bool;
            default = options.ipv4.isDefined;
          };
          ipv6_defined = mkOption {
            type = types.bool;
            default = options.ipv6.isDefined;
          };
          create_domain = mkOption {
            type = bool;
            default = false;
          };
          domain = mkOption {
            type = nullOr str;
            default = "${nixos.networking.hostName}${if config.prefix != null then ".${config.prefix}" else ""}";
          };
          prefix = mkOption {
            type = nullOr str;
            default = null;
          };
          zone = mkOption {
            type = nullOr str;
            default = "kittywit.ch.";
          };
          target = mkOption {
            type = nullOr str;
            default = "${config.domain}.${config.zone}";
          };
        };
      }));
    };
  };
  config = {
    networks = {
        internet = {
          create_domain = true;
        };
        chitei = {
          create_domain = true;
        };
        gensokyo = {
          zone = mkDefault "gensokyo.zone.";
          create_domain = true;
        };
        tailscale = {
          interfaces = singleton "tailscale0";
          ipv4 = meta.tailnet.${config.networking.hostName}.ipv4 or null;
          ipv6 = meta.tailnet.${config.networking.hostName}.ipv6 or null;
          zone = "inskip.me.";
          create_domain = true;
        };
      };

    networking.domain = "inskip.me";

    deploy.tf = {
      dns.records = let
        # Families of address to create domains for
        address_families = [ "ipv4" "ipv6" ];
        domains = config.domains;
        # Merge the result of a map upon address_families to mapAttrs'
        domains' = map (family: mapAttrs' (name: settings: let
          network = if settings.host != config.networking.hostName then
            meta.network.nodes.nixos.${settings.host}.networks.${settings.network}
          else config.networks.${settings.network};
        in nameValuePair "${settings.network}-${if settings.type == "both" || settings.type == family then family else settings.type}-${settings.domain}-${settings.zone}" ({
            inherit (settings) domain zone;
            enable = mkDefault false;
          } // (optionalAttrs (settings.type == "cname" && family == "ipv4") {
            cname = { inherit (network) target; };
            enable = mkForce true;
          }) // (optionalAttrs (network.ipv6_defined && family == "ipv6" && (settings.type == "both" || settings.type == family)) {
            aaaa.address = network.ipv6;
            enable = mkForce network.ipv6_defined;
          })
          // (optionalAttrs (!network.ipv4_defined && !network.ipv6_defined) {
            a.address = "127.0.0.1";
            enable = mkForce false;
          }) // (optionalAttrs (network.ipv4_defined && family == "ipv4" && (settings.type == "both" || settings.type == family)) {
            a.address = network.ipv4;
            enable = mkForce network.ipv4_defined;
          }))) domains) address_families;
        networks = config.networks;
        # Networks to actually create domains for
        networks' = filterAttrs (_: settings: settings.create_domain) networks;
        # Merge the result of a map upon address_families to mapAttrs'
        networks'' = map (family: mapAttrs' (network: settings:
          nameValuePair "${network}-${family}-${settings.domain}-${settings.zone}" ({
            inherit (settings) domain zone;
          } // (if family == "ipv6" then {
            aaaa.address = settings.ipv6;
            enable = mkForce settings.ipv6_defined;
          } else {
            enable = mkForce settings.ipv4_defined;
            #a.address = if settings.ipv4_defined then settings.ipv4 else "127.0.0.1";
            a.address = settings.ipv4;
          })
        )) networks') address_families;
      in mkMerge (networks'' ++ domains');

      acme = let
          home = meta.deploy.targets.home.tf;
      in {
        enable = true;
        account = {
          emailAddress = "kat@inskip.me";
          accountKeyPem = home.resources.acme_private_key.importAttr "private_key_pem";
        };
        challenge = {
          defaultProvider = "rfc2136";
          configs.rfc2136 = {
            RFC2136_NAMESERVER = tf.variables.katdns-address.ref;
            RFC2136_TSIG_KEY = tf.variables.katdns-name.ref;
            RFC2136_TSIG_SECRET = tf.variables.katdns-key.ref;
            RFC2136_TSIG_ALGORITHM = "hmac-sha512";
          };
        };
        certs = let
          hostnames = (attrValues (mapAttrs (network: settings: removeSuffix "." settings.target) config.networks))
          ++ (attrValues (mapAttrs (network: settings: removeSuffix "." settings.target) config.domains));
        in listToAttrs (map (hostname:
        nameValuePair hostname {
          keyType = "4096";
          dnsNames = singleton hostname;
        }) hostnames);
      };

      variables = {
        tailscale-authkey.export = true;
        tailscale-apikey = {
          value.shellCommand = "${meta.kw.secrets.command} secrets/tailscale -f api_key";
          sensitive = true;
          export = true;
        };
      };
      providers.tailscale = {
        inputs = {
          api_key = tf.variables.tailscale-apikey.ref;
          tailnet = "inskip.me";
        };
      };
      resources.tailnet_key = {
        provider = "tailscale";
        type = "tailnet_key";
        inputs = {
          reusable = false;
          ephemeral = false;
          preauthorized = true;
        };
      };
    };

    secrets.files = let
          hostnames = (attrValues (mapAttrs (network: settings: removeSuffix "." settings.target) config.networks))
          ++ (attrValues (mapAttrs (network: settings: removeSuffix "." settings.target) config.domains));
        in listToAttrs (map (hostname:
        nameValuePair "${hostname}-cert" {
          text = tf.acme.certs.${hostname}.out.refFullchainPem;
          owner = "nginx";
          group = "nginx";
        }) hostnames) // listToAttrs (map (hostname:
        nameValuePair "${hostname}-key" {
          text = tf.acme.certs.${hostname}.out.refPrivateKeyPem;
          owner = "nginx";
          group = "nginx";
        }) hostnames);

    services.nginx.virtualHosts = let
          hostnames = (attrValues (mapAttrs (network: settings: removeSuffix "." settings.target) config.networks))
          ++ (attrValues (mapAttrs (network: settings: removeSuffix "." settings.target) config.domains));
        in listToAttrs (map (hostname:
        nameValuePair hostname {
          forceSSL = true;
          sslCertificate = config.secrets.files."${hostname}-cert".path;
          sslCertificateKey = config.secrets.files."${hostname}-key".path;
        }) hostnames);

    networking.firewall = {
      interfaces = mkMerge (mapAttrsToList (network: settings:
        genAttrs settings.interfaces (_: { allowedTCPPortRanges = settings.tcp; allowedUDPPortRanges = settings.udp; })
      ) (removeAttrs config.networks ["tailscale"]));
      trustedInterfaces = [ "tailscale0" ];
      allowedTCPPorts = [ 5200 ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };


    services.tailscale.enable = true;

    systemd.services.tailscale-autoconnect = mkIf (builtins.getEnv "TF_IN_AUTOMATION" != "" || tf.state.enable) {
      description = "Automatic connection to Tailscale";

# make sure tailscale is running before trying to connect to tailscale
      after = [ "network-pre.target" "tailscale.service" ];
      wants = [ "network-pre.target" "tailscale.service" ];
      wantedBy = [ "multi-user.target" ];

# set this service as a oneshot job
      serviceConfig.Type = "oneshot";

# have the job run this shell script
      script = with pkgs; ''
# wait for tailscaled to settle
        sleep 2

# check if we are already authenticated to tailscale
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
          exit 0
            fi

# otherwise authenticate with tailscale
# to-do: --advertise-exit-node
            ${tailscale}/bin/tailscale up -authkey ${tf.resources.tailnet_key.getAttr "key"}
      '';
    };
  };
}
