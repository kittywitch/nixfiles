{std, ...}: let
  inherit (std) set;
in {
  systemd.tmpfiles.rules = set.mapToValues (username: _: "f /var/lib/systemd/linger/${username}") config.users.users;
}
