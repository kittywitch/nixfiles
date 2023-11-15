{
  tree,
  std,
  ...
}: let
  inherit (std) string;
in {
  home-manager.users.root.programs.ssh = {
    enable = true;
    extraConfig = ''
      Host orb
        HostName 127.0.0.1
        Port 32222
        User default
        IdentityFile /Users/kat/.orbstack/ssh/id_ed25519
        ProxyCommand env HOME=/Users/kat '/Applications/OrbStack.app/Contents/Frameworks/OrbStack Helper (VM).app/Contents/MacOS/OrbStack Helper (VM)' ssh-proxy-fdpass
        ProxyUseFdpass yes
    '';
  };

  home-manager.users.kat = {
    home.file = {
      ".orbstack/ssh/authorized_keys".text =
        (string.concatSep "\n" tree.home.user.data.keys)
        + ''

          ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILW2V8yL2vC/KDmIQdxhEeevKo1vGG18bvMNj9mLL/On
        '';
      ".ssh/authorized_keys".text = ''
        ${string.concatSep "\n" tree.home.user.data.keys}
      '';
    };
    programs.ssh = {
      enable = true;
      extraConfig = ''
        Host orb
          HostName 127.0.0.1
          Port 32222
          User default
          IdentityFile /Users/kat/.orbstack/ssh/id_ed25519
          ProxyCommand env HOME=/Users/kat '/Applications/OrbStack.app/Contents/Frameworks/OrbStack Helper (VM).app/Contents/MacOS/OrbStack Helper (VM)' ssh-proxy-fdpass
          ProxyUseFdpass yes
      '';
    };
  };

  nix = {
    buildMachines = [
      {
        hostName = "nixos@orb";
        system = "aarch64-linux";
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      }
      {
        hostName = "nixos@orb";
        system = "x86_64-linux";
        supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
      }
    ];
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };

  homebrew = {
    casks = [
      "orbstack"
    ];
  };
}
