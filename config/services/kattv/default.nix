{ config, pkgs, lib, ... }:

{
  services.udev.extraRules = ''
    KERNEL=="video[0-9]*", SUBSYSTEM=="video4linux", SUBSYSTEMS=="usb", ATTR{index}=="0", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0779", SYMLINK+="videomew", TAG+="systemd"
  '';

  systemd.services.kattv = {
    wantedBy = [ "dev-videomew.device" "multi-user.target" ];
    after = [ "dev-videomew.device" "nginx.service" ];
    description = "RTMP stream of kat cam";
    bindsTo = [ "dev-videomew.device" ];
    environment = pkgs.kat-tv.env;
    script = "exec ${pkgs.gst_all_1.gstreamer.dev}/bin/gst-launch-1.0 -e --no-position ${pkgs.lib.gst.pipelineShellString pkgs.kat-tv.pipeline}";
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
