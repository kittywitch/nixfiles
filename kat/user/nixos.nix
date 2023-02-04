{tree, ...}: {
  users.users.kat = {
    uid = 1000;
    isNormalUser = true;
    hashedPassword = "$6$G26zDwcywO6$YzHK1YI6X0d7x/mV6maCx6B7V3M1JdE3VqxxjNc7muxUPkZo0YYwniAB2";
    openssh.authorizedKeys = {
      inherit (tree.kat.user.data) keys;
    };
    extraGroups = [
      "wheel"
      "video"
      "systemd-journal"
      "plugdev"
      "input"
      "uinput"
    ];
  };
}
