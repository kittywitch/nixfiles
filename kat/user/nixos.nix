{tree, ...}: {
  users.users.kat = {
    uid = 1000;
    isNormalUser = true;
    openssh.authorizedKeys = {
      inherit (tree.kat.user.data) keys;
    };
    extraGroups = [
      "wheel"
      "video"
      "systemd-journal"
      "networkmanager"
      "plugdev"
      "input"
      "uinput"
    ];
  };
}
