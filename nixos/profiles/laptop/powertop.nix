{
  pkgs,
  lib,
  ...
}: {
  powerManagement.powertop.enable = true;
  systemd.services.powertop.serviceConfig.ExecStartPost = let
    deviceList = [
      "ThinkPad Dock"
      "Razer"
      "YubiKey"
      "Keychron"
    ];
    inherit (lib.strings) concatMapStrings;
    deviceCommands =
      concatMapStrings (device: ''
        for f in $(${pkgs.gnugrep}/bin/grep -Rl "${device}" /sys/bus/usb/devices/*/product); do
          ${pkgs.coreutils}/bin/echo on > $(dirname $f)/power/control
        done
      '')
      deviceList;
    execStartPost = pkgs.writeShellScriptBin "powertop-execStartPost" deviceCommands;
  in "${execStartPost}/bin/powertop-execStartPost";
}
