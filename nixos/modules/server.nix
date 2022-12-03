{ config, lib, ... }: let
  inherit (lib.options) mkOption mdDoc;
  inherit (lib.modules) mkIf;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.types) bool;
in {
  options = {
    role.server = mkOption {
      type = bool;
      description = mdDoc "Is this system's role a server?";
      default = false;
    };
  };
  config = mkIf config.role.server {
    # Prevent services from being automatically killed on log-out
    # https://wiki.archlinux.org/title/systemd/User#Automatic_start-up_of_systemd_user_instances
    systemd.tmpfiles.rules = mapAttrsToList (username: _: "f /var/lib/systemd/linger/${username}" ) config.users.users;
  };
}
