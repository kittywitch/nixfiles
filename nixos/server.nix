{
  lib,
  ...
}: let
  inherit (lib.attrsets) mapAttrsToList;
in {
  systemd.tmpfiles.rules = mapAttrsToList (username: _: "f /var/lib/systemd/linger/${username}") config.users.users;
}
