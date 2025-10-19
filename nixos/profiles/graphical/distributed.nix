{config, ...}: {
  programs.ssh.extraConfig = ''
    Host daiyousei-build
        HostName daiyousei.inskip.me
        User root
        IdentityAgent /run/user/${toString config.users.users.kat.uid}/gnupg/S.gpg-agent.ssh
        ControlMaster auto
        ControlPath ${config.users.users.kat.home}/.ssh/master-%r@%n:%p
        ControlPersist 10m
  '';
  nix = {
    buildMachines = [
      {
        hostName = "daiyousei-build";
        system = "aarch64-linux";
        protocol = "ssh-ng";
        maxJobs = 100;
        speedFactor = 1;
        supportedFeatures = ["benchmark" "big-parallel" "kvm"];
        mandatoryFeatures = [];
      }
    ];
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
