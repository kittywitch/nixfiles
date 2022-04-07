{ config, pkgs, lib, ... }:

with lib;

let
  env = {
    FREI0R_PATH = "${pkgs.frei0r}/lib/frei0r-1";
    GST_PLUGIN_SYSTEM_PATH_1_0 = with pkgs.gst_all_1; lib.makeSearchPath "lib/gstreamer-1.0" [
      gstreamer.out
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
    ];
  };
  queue_frame = {
    element."queue" = {
      leaky = "downstream";
      flush-on-eos = true;
      max-size-buffers = 3;
    };
  };
  queue_data = {
    element.queue = {
      #leaky = "downstream";
    };
  };
  videoconvert_cpu = {
    element.videoconvert = {
      n-threads = 4;
      dither = 0;
      chroma-resampler = 0;
      chroma-mode = 3;
    };
  };
  videoconvert_gpu = [
    "glupload"
    "glcolorconvert"
    "gldownload"
  ];
  encodeopts = {
    speed-preset = "veryfast";
    ref = 1;
    tune = "zerolatency";
    pass = "qual";
    #psy-tune = "film";
    #noise-reduction=0;
    quantizer = 21;
    bitrate = 8192;
    rc-lookahead = 6;
  };
  denoise = {
    element.frei0r-filter-hqdn3d = {
      spatial = 0.175;
      temporal = 0.25;
    };
  };
  encode_high = [
    {
      element.x264enc = {
        key-int-max = 150;
      } // encodeopts;
    }
    {
      caps."video/x-h264" = {
        profile = "high";
      };
    }
    "h264parse"
  ];
  tcpserversink = [
    "flvmux"
    queue_data
    {
      element.tcpserversink = {
        port = 8989;
        host = config.network.addresses.yggdrasil.nixos.ipv6.address;
      };
    }
  ];
  pipeline = [
    {
      element.fdsrc = {
        fd = 3;
      };
    }
    "matroskademux"
    "jpegdec"
    queue_frame

    videoconvert_cpu
    denoise

    videoconvert_cpu
    encode_high

    tcpserversink
  ];
in
  {
  network.firewall = {
    private.tcp.ports = [ 1935 8989 8990 ];
    public.tcp.ports = [ 4953 1935 ];
  };

  systemd.sockets.kattv = {
    wantedBy = [ "sockets.target" ];
    listenStreams = [ "0.0.0.0:4953" ];
    socketConfig = {
      Accept = true;
      Backlog = 0;
      MaxConnections = 1;
    };
  };

  systemd.services."kattv@" = {
    environment = env;
    script = "exec ${pkgs.gst_all_1.gstreamer}/bin/gst-launch-1.0 -e --no-position ${pkgs.lib.gst.pipelineShellString pipeline}";
    after = [ "nginx.service" ];
    description = "RTMP stream of kat cam";
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
