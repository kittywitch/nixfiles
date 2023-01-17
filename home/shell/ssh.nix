_: {
  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    controlPersist = "10m";
    hashKnownHosts = true;
    compression = true;
  };
}
