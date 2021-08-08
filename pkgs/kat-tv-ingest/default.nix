{ pkgs ? import <nixpkgs> { }, lib }: with lib; with pkgs.gst_all_1; let
  queue_frame = {
    element."queue" = {
      leaky = "downstream";
      flush-on-eos = true;
      max-size-buffers = 3;
    };
  };
  queue_data = {
    element.queue = {
      leaky = "downstream";
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
    # TODO: vulkancolorconvert?
    "glupload"
    "glcolorconvert"
    "gldownload"
  ];
  cameracapture = {
    element."v4l2src" = {
      device = "/dev/videomew";
      saturation = 100;
      brightness = 100;
      extra-controls = "c,exposure_auto=3";
    };
  };
  v4l2src = [
    cameracapture
    {
      caps."image/jpeg" = {
        width = 1280;
        height = 720;
        framerate = "30/1"; # "10/1"
      };
    }
    "jpegdec"
    queue_frame
  ];
  filesrc = [
    {
      element.filesrc = {
        location = "rawvid.mkv";
      };
    }
    "matroskademux"
  ];
  denoise = {
    element.frei0r-filter-hqdn3d = {
      spatial = 0.175; #0.325;
      temporal = 0.06; #0.11;
    };
  };
  encodeopts = {
    speed-preset = "ultrafast";
    tune = "zerolatency";
    pass = "qual";
    #psy-tune = "film";
    #noise-reduction=0;
    quantizer = 27;
    bitrate = 8192;
    rc-lookahead = 6;
  };
  encode_intra = [
    {
      element.x264enc = {
        intra-refresh = true;
        key-int-max = 0;
      } // encodeopts;
    }
    {
      caps."video/x-h264" = {
        profile = "high-4:2:2-intra";
      };
    }
    "h264parse"
  ];
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
  rtmpsink = [
    queue_data
    "flvmux"
    {
      element.rtmp2sink = {
        location = "rtmp://localhost:1935/stream/kattv";
      };
    }
  ];
  filesink = [
    "matroskamux"
    {
      element.filesink = {
        location = "out.mkv";
      };
    }
  ];
  videosink = "autovideosink";
  pipeline = [
    #filesrc
    #v4l2src
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

    rtmpsink
    #filesink
  ];
  #gst-launch-1.0 $camera ! $videoconvert ! $queue ! $denoise ! $encode ! $outfile
  env = {
    FREI0R_PATH = "${pkgs.frei0r}/lib/frei0r-1";
    GST_PLUGIN_SYSTEM_PATH_1_0 = with pkgs.gst_all_1; lib.makeSearchPath "lib/gstreamer-1.0" [
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
    ];
  };
  shell = pkgs.mkShell (env // {
    nativeBuildInputs = [ gstreamer kattv ];
  });
in
{
  inherit shell pipeline env;
}
#!/usr/bin/env bash
/*




  #encode='x264enc intra-refresh=true key-int-max=0 speed-preset=superfast tune=zerolatency pass=qual psy-tune=film noise-reduction=250 quantizer=23 rc-lookahead=15 ! video/x-h264,profile=high-4:2:2-intra ! h264parse'
  #encode="x264enc intra-refresh=true key-int-max=0 $encodeopts ! video/x-h264,profile=high-4:2:2-intra ! h264parse ! $bufqueue"
  encode="x264enc key-int-max=50 $encodeopts ! video/x-h264,profile=high-4:2:2 ! h264parse ! $bufqueue"

  # original pipeline:
  # gst-launch-1.0 v4l2src device=/dev/video0 ! "video/x-raw,format=YUY2,width=1280,height=800,framerate=10/1" ! videoconvert ! x264enc intra-refresh=true key-int-max=0 speed-preset=superfast tune=zerolatency pass=qual psy-tune=film noise-reduction=250 quantizer=23 rc-lookahead=15 ! video/x-h264,profile=high-4:2:2-intra ! h264parse ! flvmux ! rtmpsink location="rtmp://kittywit.ch/kattv/meowlymeowl live=1"


  #gst-launch-1.0 filesrc location=rawvid.mkv ! mkvdemux ! "video/x-raw,format=YUY2,width=1280,height=800,framerate=10/1" ! videoconvert ! x264enc intra-refresh=true key-int-max=0 speed-preset=superfast tune=zerolatency pass=qual psy-tune=film noise-reduction=250 quantizer=23 rc-lookahead=15 ! video/x-h264,profile=high-4:2:2-intra ! h264parse ! flvmux ! filesink location=out.flv

  #gst-launch-1.0 filesrc location=rawvid.mkv ! matroskademux ! "video/x-raw,format=YUY2,width=1280,height=800,framerate=10/1" ! videoconvert ! "video/x-raw,format=RGBA" ! frei0r-filter-hqdn3d spatial=0.35 temporal=0.115 ! videoconvert ! autovideosink

  outfile='flvmux ! filesink location=out.flv'
  #gst-launch-1.0 $camera ! $videoconvert ! $denoise ! autovideosink
  gst-launch-1.0 $camera ! $videoconvert ! $queue ! $denoise ! $encode ! $outfile
  #gst-launch-1.0 $camera ! $videoconvert ! $encode ! $outfile
*/
