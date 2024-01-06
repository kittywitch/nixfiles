{tree, ...}: {
  users.users.kat = {
    uid = 1000;
    isNormalUser = true;
    linger = true;
    openssh.authorizedKeys = {
      inherit (tree.home.user.data) keys;
    };
    extraGroups = [
      "wheel"
      "video"
      "systemd-journal"
      "networkmanager"
      "plugdev"
      "input"
      "uinput"
      "adbusers"
    ];
  };
}
