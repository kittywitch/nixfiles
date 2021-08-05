{ lib, config, users, pkgs, profiles, ... }:

with lib;

{
  imports = [ ./hw.nix profiles.laptop ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostId = "9f89b327";
  networking.hostName = "ostara";

  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  kw.fw.public.interfaces = singleton "wlp2s0";

  kw.fw.public.tcp.ports = [ 9981 9982 ];

  hardware.firmware = [ pkgs.libreelec-dvb-firmware ];

  services.tvheadend.enable = true;

  systemd.services.tvheadend.enable = lib.mkForce false;
  
  systemd.services.tvheadend-kat = {
      description = "Tvheadend TV streaming server";
      wantedBy    = [ "multi-user.target" ];
      after       = [ "network.target" ];
      script   = ''
                      ${pkgs.tvheadend}/bin/tvheadend \
                      --http_root /tvheadend \
                      --http_port 9981 \
                      --htsp_port 9982 \
                      -f \
                      -C \
                      -p ${config.users.users.tvheadend.home}/tvheadend.pid \
                      -u tvheadend \
                      -g video
                      '';
      serviceConfig = {
        Type         = "forking";
        PIDFile      = "${config.users.users.tvheadend.home}/tvheadend.pid"; 
        Restart      = "always";
        RestartSec   = 5;
        User         = "tvheadend";
        Group        = "video";
       
        ExecStop     = "${pkgs.coreutils}/bin/rm ${config.users.users.tvheadend.home}/tvheadend.pid";
      };
    };


  system.stateVersion = "20.09";
}
