{ config, base16, pkgs, lib, ... }: with lib; {
  systemd.user.services.polybar.Service.Environment = mkForce [
    "PATH=/nix/store/bmh5zjsihnyim0pmhgnnmn4adribvns6-polybar-3.5.7/bin:/run/wrappers/bin"
    "NOTMUCH_CONFIG=${config.home.sessionVariables.NOTMUCH_CONFIG}"
  ];
  services.polybar = {
    enable = true;
    script = let
      xrandr = filter: "${pkgs.xorg.xrandr}/bin/xrandr -q | ${pkgs.gnugrep}/bin/grep -F ' ${filter}' | ${pkgs.coreutils}/bin/cut -d' ' -f1";
    in mkIf config.xsession.enable ''
        primary=$(${xrandr "connected primary"})
        for display in $(${xrandr "connected"}); do
          export POLYBAR_MONITOR=$display
          export POLYBAR_MONITOR_PRIMARY=$([[ $primary = $display ]] && echo true || echo false)
          export POLYBAR_TRAY_POSITION=$([[ $primary = $display ]] && echo right || echo none)
          polybar kat &
        done
    '';
    package = pkgs.polybarFull;
    config = {
      "bar/base" = {
        modules-left = mkMerge [
          (mkIf config.xsession.windowManager.i3.enable (mkBefore [ "i3" ]))
          [ "title" ]
        ];
        modules-center = mkMerge [
          (mkAfter [ "arc" "hex" "miku" "date" ])
          ];
          modules-right = mkMerge [
          (mkOrder 1240 [ "pulseaudio" "headset" "mail" ])
          (mkOrder 1250 [ "cpu" "temp" "ram" "net-enp34s0" ])
          (mkOrder 1490 [ "gpg" ])
          ];
          };
          };
          settings = let
          colours = base16.map.hash.argb;
          warn-colour = colours.constant; # or deleted
          in with colours; {
          "bar/kat" = {
            "inherit" = "bar/base";
            monitor = {
              text = mkIf config.xsession.enable "\${env:POLYBAR_MONITOR:}";
            };
            height = 20;
            enable-ipc = true;
            tray = {
              maxsize = 12;
              position = "\${env:POLYBAR_TRAY_POSITION:right}";
            };
            offset = {
              x = 0;
              y = 0;
            };
            dpi = {
              x = 0;
              y = 0;
            };
            spacing = 0;
            scroll = {
              up = "#i3.prev";
              down = "#i3.next";
            };
            font = [
              "${config.kw.theme.font.name}:size=9;2"
              "Font Awesome 5 Free Solid:size=9;2"
              "Font Awesome 5 Free Brands:size=9;2"
              ];
              padding = {
              left = 1;
              right = 1;
              };
              separator = {
              text = " ";
              foreground = foreground_status;
            };
            background = "#b219171c";
            foreground = foreground_alt;
            border = {
              bottom = {
                size = 1;
                color = background_light;
              };
            };
            module-margin = 0;
          #click-right = ""; menu of some sort?
        };
        "module/i3" = mkIf config.xsession.windowManager.i3.enable {
          type = "internal/i3";
          pin-workspaces = true;
          strip-wsnumbers = true;
          wrapping-scroll = false;
          enable-scroll = false; # handled by bar instead
          label = {
            mode = {
              padding = 2;
              foreground = constant;
              background = background_selection;
            };
            focused = {
              text = "%name%";
              padding = 2;
              foreground = background_alt;
              background = regex;
            };
            unfocused = {
              text = "%name%";
              padding = 2;
              foreground = foreground_alt;
              background = background_light;
            };
            visible = {
              text = "%name%";
              padding = 2;
              foreground = foreground;
                #background = background;
            };
            urgent = {
              text = "%name%";
              padding = 2;
              foreground = foreground_status;
              background = link;
              };
            };
          };
          "module/title" = {
            type = "internal/xwindow";
            label = {
              text = "%title:0:50:%";
              padding = 1;
            };
            format = {
              text = "<label>";
              background = background_light;
            };
            format-prefix = {
              text = "";
              padding = 1;
              background = regex;
            };
          };
          "module/sep" = {
            type = "custom/text";
            content = {
              text = "|";
              foreground = comment;
            };
          };
          "module/ram" = {
            type = "internal/memory";
            interval = 4;
            format-prefix = {
              padding = 1;
              text = "";
              background = constant;
            };
            label = {
              text = "%percentage_used%%";
              padding = 1;
              background = background_light;
            };
            warn-percentage = 90;
            format.warn.foreground = warn-colour;
          };
          "module/cpu" = {
            type = "internal/cpu";
            format-prefix = {
              background = variable;
              padding = 1;
              text = "";
            };
            label = {
              text = "%percentage%%";
              padding = 1;
              background = background_light;
            };
            interval = 2;
            warn-percentage = 90;
            format.warn.foreground = warn-colour;
          };
          "module/mpd" = let
            ncmpcpp = config.programs.ncmpcpp;
          in mkIf ncmpcpp.enable {
            type = "internal/mpd";

            host = mkIf (ncmpcpp.mpdHost != null) ncmpcpp.mpdHost;
            password = mkIf (ncmpcpp.mpdPassword != null) ncmpcpp.mpdPassword;
            port = mkIf (ncmpcpp.mpdPort != null) ncmpcpp.mpdPort;

            interval = 1;
            label-song = "♪ %artist% - %title%";
            format = {
              online = "<label-time> <label-song>";
              playing = "\${self.format-online}";
            };
          };
          "module/net-enp34s0" = {
            type = "internal/network";
            interface = "enp34s0";
            format = {
              connected = "<label-connected>";
              disconnected = "<label-disconnected>";
            };
            label = {
              connected = {
                text = "";
                padding = 1;
                background = regex;
              };
              disconnected = {
                text = "";
                padding = 1;
                background = regex;
              };
            };
          };
          "module/pulseaudio" = {
            type = "internal/pulseaudio";
            use-ui-max = false;
            interval = 5;
            format-muted-prefix = {
              padding = 1;
              background = warn-colour;
              text = "";
            };
            format = {
              background = background_light;
            };
            format.volume = {
              text = "<ramp-volume><label-volume>";
              background = background_light;
            };
            ramp.volume = [
              ""
              ""
              ""
            ];
            ramp-volume-background = keyword;
            ramp-volume-padding = 1;
            label = {
              volume = {
                background = background_light;
                padding = 1;
              };
              muted = {
                padding = 1;
                text = "muted";
                background = background_light;
                foreground = warn-colour;
              };
            };
            click-right = "${pkgs.kitty}/bin/kitty pulsemixer";
          };
          "module/date" = {
            type = "internal/date";
            label = "%date% %time%";
            format = {
              text = "<label>";
              padding = 1;
              background = background_light;
            };
            interval = 1;
            date = "%a, %F";
            time = "%T";
          };
          "module/headset" = {
            type = "custom/script";
            interval = 60;
            exec-if = "${pkgs.headsetcontrol}/bin/headsetcontrol -c";
            exec = "${pkgs.headsetcontrol}/bin/headsetcontrol -b | ${pkgs.gnugrep}/bin/grep Battery | ${pkgs.coreutils}/bin/cut -d ' ' -f2";
            format-prefix = {
              text = "";
              padding = 1;
              background = string;
            };
            label.padding = 1;
            format = {
              background = background_light;
              text = "<label>";
            };
          };
          "module/gpg" = {
            type = "custom/script";
            interval = 60;
            exec = let
              gpgScript = pkgs.writeShellScriptBin "kat-gpg-status" ''
set -eu
set -o pipefail

if gpg --card-status &> /dev/null; then
  #user="$(gpg --card-status | grep 'Login data' | awk '{print $NF}')";
	status='%{B${string}}  %{B-}'
else
	status='%{B${variable}}  %{B-}'
fi

echo $status
              '';
              gpgScriptWrapped = pkgs.wrapShellScriptBin "kat-gpg-status" "${gpgScript}/bin/kat-gpg-status" { depsRuntimePath = with pkgs; [ coreutils gnugrep gawk gnupg ]; };
            in "${gpgScriptWrapped}/bin/kat-gpg-status";
          };
          "module/arc" = {
            type = "custom/script";
            exec = "TZ=America/Vancouver ${pkgs.coreutils}/bin/date +-%H";
            format-prefix = {
              text = "";
              padding = 1;
              background = string;
            };
            label.padding = 1;
            format = {
              background = background_light;
              text = "<label>";
            };
            interval = 60;
          };
          "module/hex" = {
            type = "custom/script";
            exec = "TZ=Europe/Berlin ${pkgs.coreutils}/bin/date ++%H";
            format-prefix = {
              text = "";
              padding = 1;
              background = support;
            };
            label.padding = 1;
            format = {
              background = background_light;
              text = "<label>";
            };
            interval = 60;
          };
          "module/miku" = {
            type = "custom/script";
            exec = "TZ=Pacific/Auckland ${pkgs.coreutils}/bin/date ++%H";
            format-prefix = {
              text = "";
              padding = 1;
              background = keyword;
            };
            label.padding = 1;
            format = {
              background = background_light;
              text = "<label>";
            };
            interval = 60;
          };
          "module/mail" = {
            type = "custom/script";
            exec = "${pkgs.notmuch-arc}/bin/notmuch count tag:flagged OR tag:inbox AND NOT tag:killed";
            interval = 60;
            label = {
              padding = 1;
              background = background_light;
            };
            format-prefix = {
              text = "";
              background = deprecated;
              padding = 1;
            };
          };
          "module/temp" = {
            type = "internal/temperature";
            ramp = ["" "" ""];
            ramp-background = string;
            ramp-padding = 1;
            ramp-2-background = warn-colour;
            interval = mkDefault 5;
            base-temperature = mkDefault 30;
            format = {
              text = "<ramp><label>";
            };
            label = {
              padding = 1;
              background = background_light;
              text = "%temperature-c%";
              warn.foreground = warn-colour;
            };

          # $ for i in /sys/class/thermal/thermal_zone*; do echo "$i: $(<$i/type)"; done
          #thermal-zone = 0;

          # Full path of temperature sysfs path
          # Use `sensors` to find preferred temperature source, then run
          # $ for i in /sys/class/hwmon/hwmon*/temp*_input; do echo "$(<$(dirname $i)/name): $(cat ${i%_*}_label 2>/dev/null || echo $(basename ${i%_*})) $(readlink -f $i)"; done
          # Default reverts to thermal zone setting
          #hwmon-path = ?
        };
        "module/net-wlan" = {
          type = "internal/network";
          interface = mkIf (! config.home.nixos.networking.wireless.iwd.enable or false) (mkDefault "wlan");
          label = {
            connected = {
              text = "📶 %essid% %downspeed:9%";
              foreground = inserted;
            };
            disconnected = {
              text = "Disconnected.";
              foreground = warn-colour;
            };
          };
          format-packetloss = "<animation-packetloss> <label-connected>";
          animation-packetloss = [
            {
              text = "!"; # ⚠
              foreground = warn-colour;
            }
            {
              text = "📶";
              foreground = warn-colour;
            }
          ];
        };
        "module/net-wired" = {
          type = "internal/network";
          label = {
            connected = {
              text = "%ifname% %local_ip%";
              foreground = inserted;
            };
            disconnected = {
              text = "Unconnected.";
              foreground = warn-colour; # or deleted
            };
          };
          # TODO: formatting
        };
        "module/fs-prefix" = {
          type = "custom/text";
          content = {
            text = "💽";
          };
        };
        "module/fs-root" = {
          type = "internal/fs";
          mount = mkBefore [ "/" ];
          label-mounted = "%mountpoint% %free% %percentage_used%%";
          label-warn = "%mountpoint% %{F${warn-colour}}%free% %percentage_used%%%{F-}";
          label-unmounted = "";
          warn-percentage = 90;
          spacing = 1;
        };
        "module/mic" = {
          type = "custom/ipc";
          format = "🎤 <output>";
          initial = 1;
          click.left = "${config.home.nixos.hardware.pulseaudio.package or pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle && ${config.services.polybar.package}/bin/polybar-msg hook mic 1";
          # check if pa default-source is muted, if so, show warning!
          # also we trigger an immediate refresh when hitting the keybind
          hook = let
            pamixer = "${pkgs.pamixer}/bin/pamixer --default-source";
            script = pkgs.writeShellScript "checkmute" ''
              set -eu
              MUTE=$(${pamixer} --get-mute || true)
              if [[ $MUTE = true ]]; then
                echo muted
              else
                echo "$(${pamixer} --get-volume)%"
              fi
            '';
          in singleton "${script}";
        };
      };
    };
  }
