{ config, lib, ... }: let
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) mapAttrsToList;
in {
  config = mkIf config.role.server {
    # Prevent services from being automatically killed on log-out
    # https://wiki.archlinux.org/title/systemd/User#Automatic_start-up_of_systemd_user_instances
    systemd.tmpfiles.rules = mapAttrsToList (username: _: "f /var/lib/systemd/linger/${username}" ) config.users.users;
  };
}
