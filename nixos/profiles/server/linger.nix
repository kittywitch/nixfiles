{config, ...}: {
  # Allow services to persist for a user after their sessions have ran out
  systemd.tmpfiles.rules = set.mapToValues (username: _: "f /var/lib/systemd/linger/${username}") config.users.users;
}
