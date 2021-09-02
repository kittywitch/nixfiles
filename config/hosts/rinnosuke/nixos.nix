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
    services.knot
    services.nginx
  ];

  kw.oci = {
    base = "Canonical Ubuntu";
    specs = {
      shape = "VM.Standard.E2.1.Micro";
      cores = 1;
      ram = 1;
      space = 50;
    };
    ad = 2;
    network = {
      publicV6 = 7;
      privateV4 = 3;
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
    interfaces.ens3 = {
      useDHCP = true;
      ipv6 = {
        addresses = mkIf (config.network.addresses.public.nixos.ipv6.enable) [{
          address = config.network.addresses.public.nixos.ipv6.address;
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
    dns.enable = false;
    addresses = {
      public = {
        enable = true;
        nixos.ipv6.address = mkIf (tf.state.resources ? ${tf.resources.${config.networking.hostName}.out.reference}) addr_ipv6_nix;
        tf.ipv6.address = tf.resources.rinnosuke_ipv6.refAttr "ip_address";
      };
    };
    firewall.public.interfaces = singleton "ens3";
    tf = {
      enable = true;
      ipv4_attr = "public_ip";
    };
  };
}
