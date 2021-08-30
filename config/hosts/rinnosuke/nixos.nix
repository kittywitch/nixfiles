{ config, tf, meta, kw, pkgs, lib, sources, ... }: with lib; let
  oci-root = meta.deploy.targets.oci-root.tf;
  addr_ipv6_nix = let
    prefix = head (splitString "/" (oci-root.resources.oci_kw_subnet.importAttr "ipv6cidr_block"));
  in assert hasSuffix "::" prefix; prefix + "7";
in
  {
    imports = (with (import (sources.tf-nix + "/modules")); [
      nixos.ubuntu-linux
      nixos.oracle
      ./oracle.nix
    ]) ++ (with meta; [
      services.knot
      services.nginx
    ]);

    services.nginx.virtualHosts =
      let
        splashy = pkgs.host-splash-site config.networking.hostName;
      in
      kw.virtualHostGen {
        networkFilter = [ "public" ];
        block.locations."/" = { root = splashy; };
      };

      networking = {
        useDHCP = false;
        hostName = "rinnosuke";
        interfaces.ens3 = {
          useDHCP = true;
          ipv6 = {
            addresses = [{
              address = config.network.addresses.public.ipv6.address;
              prefixLength = 64;
            }];
            routes = [{
                address = "::";
                prefixLength = 0;
            }];
          };
        };
      };

      network = {
        addresses = {
          public = {
            enable = true;
            ipv6.address = mkIf (tf.state.resources ? ${tf.resources.${config.networking.hostName}.out.reference}) addr_ipv6_nix;
          };
        };
        firewall.public.interfaces = singleton "ens3";
        tf = {
          enable = true;
          ipv4_attr = "public_ip";
        };
      };
    }
