{ meta, config, pkgs, lib, ... }:

let
  env = {
    FREI0R_PATH = "${pkgs.frei0r}/lib/frei0r-1";
    GST_PLUGIN_SYSTEM_PATH_1_0 = with pkgs.gst_all_1; lib.makeSearchPath "lib/gstreamer-1.0" [
      gstreamer.out
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
      pkgs.gst-jpegtrunc
    ];
  };
  cameracapture = {
    element."v4l2src" = {
      device = "/dev/videomew";
      brightness = 100;
      #extra-controls = "c,exposure_auto=3";
    };
  };
  queue_data = {
    element.queue = {
      leaky = "downstream";
    };
  };
  v4l2src = [
    cameracapture
    {
      caps."image/jpeg" = {
        width = 1920;
        height = 1080;
        framerate = "30/1"; # "10/1"
      };
    }
  ];
  pipeline = v4l2src ++ [
    "jpegtrunc"
    queue_data
    { element.matroskamux.streamable = true; }
    {
      element.tcpclientsink = {
        host = meta.network.nodes.nixos.yukari.network.addresses.private.nixos.ipv4.address;
        port = "4953";
        sync = false;
      };
    }
  ];
in
{
  services.udev.extraRules = ''
    KERNEL=="video[0-9]*", SUBSYSTEM=="video4linux", SUBSYSTEMS=="usb", ATTR{index}=="0", ATTRS{idVendor}=="1c3f", ATTRS{idProduct}=="2002", SYMLINK+="videomew", TAG+="systemd"
  '';

  systemd.services.kattv = {
    wantedBy = [ "dev-videomew.device" "multi-user.target" ];
    after = [ "dev-videomew.device" "nginx.service" ];
    description = "RTMP stream of kat cam";
    bindsTo = [ "dev-videomew.device" ];
    environment = env;
    script = "exec ${pkgs.gst_all_1.gstreamer}/bin/gst-launch-1.0 -e --no-position ${pkgs.lib.gst.pipelineShellString pipeline}";
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
