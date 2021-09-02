{ config, tf, meta, kw, pkgs, lib, sources, ... }: with lib; let
  oci-root = meta.deploy.targets.oci-root.tf;
  addr_ipv6_nix =
    let
      prefix = head (splitString "/" (oci-root.resources.oci_kw_subnet.importAttr "ipv6cidr_block"));
    in
    assert hasSuffix "::" prefix; prefix + toString config.kw.oci.network.publicV6;
in
{
  imports = with meta; [
    profiles.hardware.oracle.ubuntu
    services.nginx
  ];

  deploy.tf.providers.local = { };

  nixpkgs.localSystem = systems.examples.aarch64-multiplatform // {
    system = "aarch64-linux";
  };

  kw.oci = {
    base = "Canonical Ubuntu";
    specs = {
      shape = "VM.Standard.A1.Flex";
      cores = 4;
      ram = 24;
      space = 100;
    };
    ad = 1;
    network = {
      publicV6 = 6;
      privateV4 = 5;
    };
  };

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
    interfaces.enp0s3 = {
      useDHCP = true;
      ipv6 = {
        addresses = mkIf (tf.state.resources ? ${tf.resources.${config.networking.hostName}.out.reference}) [{
          address = addr_ipv6_nix;
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
        # TODO: move into module
        nixos.ipv6.address = mkIf (tf.state.resources ? ${tf.resources.${config.networking.hostName}.out.reference}) addr_ipv6_nix;
        tf.ipv6.address = tf.resources."${config.networking.hostName}_ipv6".refAttr "ip_address";
      };
    };
    firewall.public.interfaces = singleton "enp0s3";
    tf = {
      enable = true;
      ipv4_attr = "public_ip";
    };
  };
}
