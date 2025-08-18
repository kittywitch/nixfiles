{lib, ...}: let
  inherit (lib.generators) toJSON;

  mullvadSettings = builtins.toJSON {
    allow_lan = true;
    auto_connect = true;
    block_when_disconnected = true;
  };
in {
  services.mullvad-vpn.enable = true;

  #sops.secrets.mullvad-vpn-account-number = {
  #sopsFile = ./secrets.yaml;
  #};

  systemd = {
    services."mullvad-daemon".environment.MULLVAD_SETTINGS_DIR = "/var/lib/mullvad-vpn";
    tmpfiles.settings."10-mullvad-settings" = {
      "/var/lib/mullvad-vpn/settings.json"."C+" = {
        group = "root";
        mode = "0700";
        user = "root";
        argument = "${mullvadSettings}";
      };
    };
  };
}
