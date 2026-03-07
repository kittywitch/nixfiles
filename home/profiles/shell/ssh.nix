{
  programs.ssh = {
    enable = true;
    matchBlocks."*" = {
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlMaster = "auto";
      controlPersist = "10m";
      hashKnownHosts = true;
      userKnownHostsFile = "~/.ssh/known_hosts";
      compression = true;
      forwardAgent = true;
      addKeysToAgent = "no";
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
    };
  };
}
