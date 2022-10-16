{ config, tf, meta, nixfiles, pkgs, lib, ... }: with lib; {
  imports = with meta; [
    hardware.oracle.ubuntu
    services.nginx
    services.knot
  ];

  nixfiles.oci = {
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

  system.stateVersion = "21.11";
}
