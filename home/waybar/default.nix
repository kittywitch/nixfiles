{ config, lib, pkgs, kw, ... }:

{
	xdg.configFile."waybar/style.css" = { inherit (kw.sassTemplate { name = "waybar-style"; src = ./waybar.sass; }) source; };

#systemd.user.services.waybar.Service.Environment = lib.singleton "NOTMUCH_CONFIG=${config.home.sessionVariables.NOTMUCH_CONFIG}";

	programs.waybar = {
		enable = true;
		systemd.enable = true;
		settings = [{
			height = 10;
			modules-left = [
				"sway/workspaces"
					"sway/mode"
					"sway/window"
			];
			modules-center = [
				"clock#original"
			];
			modules-right = [
				"pulseaudio#icon"
					"pulseaudio"
					"custom/headset-icon"
					"custom/headset"
					"custom/mail-icon"
					"custom/mail"
					"custom/cpu-icon"
					"cpu"
					"custom/memory-icon"
					"memory"
					"temperature#icon"
					"temperature"
					"battery#icon"
					"battery"
					"backlight#icon"
					"backlight"
					"network"
					"idle_inhibitor"
					"custom/konawall"
					"custom/gpg-status"
					"tray"
					];

			modules = {
				"sway/workspaces" = {
					format = "{icon}";
					format-icons = {
						"1" = "1:";
						"2" = "2:";
						"3" = "3:";
					};
				};
				"sway/window" = {
					icon = true;
					format = "{}";
				};
				tray = {
					icon-size = 12;
					spacing = 2;
				};
				backlight = {
					format = "{icon} {percent}%";
					format-icons = ["" ""];
				};
				"custom/gpg-status" = {
					format = "{}";
					interval = 300;
					return-type = "json";
					exec = "${pkgs.waybar-gpg}/bin/kat-gpg-status";
				};
				"custom/headset-icon" = {
					format = "";
					interval = 60;
					exec-if = "${pkgs.headsetcontrol}/bin/headsetcontrol -c";
					exec = "echo 'mew'";
				};
				"custom/headset" = {
					format = "{}";
					interval = 60;
					exec-if = "${pkgs.headsetcontrol}/bin/headsetcontrol -c";
					exec = "${pkgs.headsetcontrol}/bin/headsetcontrol -b | ${pkgs.gnugrep}/bin/grep Battery | ${pkgs.coreutils}/bin/cut -d ' ' -f2";
				};
				"custom/konawall" = {
					format = "{}";
					interval = "once";
					return-type = "json";
					exec = "${pkgs.waybar-konawall}/bin/konawall-status";
					on-click = "${pkgs.waybar-konawall}/bin/konawall-toggle";
					on-click-right = "systemctl --user restart konawall";
					signal = 8;
				};
				"custom/mail-icon".format = "";
				"custom/mail" = {
					format = "{}";
					interval = 30;
					exec = "${pkgs.notmuch-arc}/bin/notmuch count tag:flagged OR tag:inbox AND NOT tag:killed";
				};
				"custom/cpu-icon".format = "";
				cpu.format = "{usage}%";
				"custom/memory-icon".format = "";
				memory.format = "{percentage}%";
				"temperature#icon" = {
					format = "{icon}";
					format-icons = ["" "" ""];
					critical-threshold = 80;
				};
				temperature = {
					format = "{temperatureC}°C";
					critical-threshold = 80;
				};
				idle_inhibitor = {
					format = "{icon}";
					format-icons = {
						activated = "";
						deactivated = "";
					};
				};
				"battery#icon" = {
					states = {
						good = 90;
						warning = 30;
						critical = 15;
					};
					format = "{icon}";
					format-charging = "";
					format-plugged = "";
					format-icons = [ "" "" "" "" "" ];
				};
				battery = {
					states = {
						good = 90;
						warning = 30;
						critical = 15;
					};
					format = "{capacity}%";
					format-charging = "{capacity}%";
					format-plugged = "{capacity}%";
					format-alt = "{time}";
				};
				"pulseaudio#icon" = {
					format = "{icon}";
					format-muted = "婢";
					on-click = "foot pulsemixer";
					format-icons = {
						default = [
							""
								""
								""
						];
					};
				};
				pulseaudio = {
					format = "{volume}%";
					on-click = "foot pulsemixer";
				};
				network = {
					format-wifi = "直";
					format-ethernet = "";
					format-linked = " {ifname} (NO IP)";
					format-disconnected = " DC";
					format-alt = "{ifname}: {ipaddr}/{cidr}";
					tooltip-format-wifi = "{essid} ({signalStrength}%)";
				};
				"clock#original" = {
					format = "{:%a, %F %T}";
					tooltip = true;
					tooltip-format = "{:%A, %F %T %z (%Z)}";
					timezones = [
						"America/Vancouver"
					];
					interval = 1;
				};
			};
		}];
	};
}
