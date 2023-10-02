_: let
  hostConfig = {
    tree,
    pkgs,
    inputs,
    std,
    ...
  }: let
    inherit (std) string;
  in {
    imports = with tree; [
      kat.work
    ];

    security.pam.enableSudoTouchIdAuth = true;

    home-manager.users.root.programs.ssh = {
      enable = true;
      extraConfig = ''
        Host orb
          HostName 127.0.0.1
          Port 32222
          User default
          IdentityFile /Users/kat/.orbstack/ssh/id_ed25519
      '';
      /*
      ProxyCommand env HOME=/Users/kat '/Applications/OrbStack.app/Contents/Frameworks/OrbStack Helper (VM).app/Contents/MacOS/OrbStack Helper (VM)' ssh-proxy-fdpass
      ProxyUseFdpass yes
      */
    };

    nix.buildMachines = [
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

    nix.distributedBuilds = true;
    nix.extraOptions = ''
      builders-use-substitutes = true
    '';

    environment.systemPackages = with pkgs; [
      fd # fd, better fine!
      terraform
      ripgrep # rg, better grep!
      deadnix # dead-code scanner
      alejandra # code formatter
      statix # anti-pattern finder
      deploy-rs.deploy-rs # deployment system
      rnix-lsp # vscode nix extensions
      kubectl # kubernetes
      k9s # cute k8s client, canines~
      kubernetes-helm # helm
      awscli2
    ];

    home-manager.users.kat = {
      home.sessionVariables = {
        ARTEMISCLI_CONFIG_PATH = "/Users/kat/.artemisconfig";
      };
      services.konawall = {
        enable = true;
        interval_macos = 3600;
        mode = "shuffle";
        commonTags = ["width:>=1600"];
        tagList = [
          [
            "score:>=50"
            #"no_humans"
            "touhou"
            "rating:s"
          ]
        ];
      };
      home.file = {
        ".orbstack/ssh/authorized_keys".text =
          (string.concatSep "\n" tree.kat.user.data.keys)
          + ''

            ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILW2V8yL2vC/KDmIQdxhEeevKo1vGG18bvMNj9mLL/On
          '';
        ".ssh/authorized_keys".text = ''
          ${string.concatSep "\n" tree.kat.user.data.keys}
        '';
      };
      programs = {
        zsh = {
          initExtra = ''
            source <(kubectl completion zsh)
          '';
        };
        ssh = {
          enable = true;
          extraConfig = ''
            Host orb
              HostName 127.0.0.1
              Port 32222
              User default
              IdentityFile /Users/kat/.orbstack/ssh/id_ed25519
          '';
          /*
            ProxyCommand env HOME=/Users/kat '/Applications/OrbStack.app/Contents/Frameworks/OrbStack Helper (VM).app/Contents/MacOS/OrbStack Helper (VM)' ssh-proxy-fdpass
          ProxyUseFdpass yes
          */
        };
      };
    };

    homebrew = {
      brewPrefix = "/opt/homebrew/bin";
      brews = [
        "gnupg"
        "pinentry-mac"
        "awscurl"
        "pandoc"
        "openjdk@17"
        "maven"
        "dependency-check"
        "snyk"
      ];
      casks = [
        "barrier"
        "bitwarden"
        "mullvadvpn"
        "firefox"
        "disk-inventory-x"
        "dozer"
        "devtoys"
        "cyberduck"
        "spotify"
        "pycharm-ce"
        "prismlauncher"
        "element"
        "logseq"
        "slack"
        "boop"
        "iterm2"
        "obsidian"
        "contexts"
        "rectangle"
        "signal"
        "telegram"
        "discord"
        "deluge"
        "keybase"
        "anki"
        "syncthing"
        "firefox"
        "google-chrome"
        "orbstack"
      ];
      taps = [
        "pulumi/tap"
        "homebrew/cask-versions"
        "snyk/tap"
      ];
      masApps = {
        Tailscale = 1475387142;
        Dato = 1470584107;
        Lungo = 1263070803;
        "Battery Indicator" = 1206020918;
      };
    };

    system.stateVersion = 4;
  };
in {
  arch = "aarch64";
  type = "macOS";
  modules = [
    hostConfig
  ];
}
