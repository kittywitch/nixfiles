{ config, tf, meta, kw, pkgs, lib, sources, ... }: with lib; {
  imports = with meta; [
    profiles.hardware.oracle.ubuntu
    profiles.network
    services.knot
    services.nginx
  ];

  kw.oci = {
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

  network = {
    yggdrasil = {
      enable = true;
      pubkey = "fc64ee574072ef7420ff98bc53856f881025de252081e661a78e04ebcf7c6b35";
      address = "200:736:2351:7f1a:2117:be00:ce87:58f5";
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

  system.stateVersion = "21.11";
}
