_: {
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
    hashKnownHosts = true;
    compression = true;
    extraConfig = ''
      Host renko
        HostName 192.168.64.3
        Port 62954
        User root
    '';
  };
}
