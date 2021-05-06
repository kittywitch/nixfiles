{ config, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    package = pkgs.mpd-youtube-dl;
    network.startWhenNeeded = true;
    musicDirectory = "/home/kat/media-share/music";
    extraConfig = ''
      max_output_buffer_size "32768"

      audio_output {
          type                    "fifo"
          name                    "my_fifo"
          path                    "/tmp/mpd.fifo"
          format                  "44100:16:2"
      }

        audio_output {
          type "pulse"
          name "speaker"
      }  


              audio_output {
                        type "httpd"
                        name "httpd-high"
                        encoder "opus"
                        bitrate "96000"
                        port "32101"
                        max_clients "4"
                        format "48000:16:2"
                        always_on "yes"
                        tags "yes"
            }
    '';
  };
}
