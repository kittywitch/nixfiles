_: let
  hostConfig = {
    tree,
    pkgs,
    ...
  }: {
    imports = with tree; [
      kat.work
    ];

    security.pam.enableSudoTouchIdAuth = true;

    home-manager.users.root.programs.ssh = {
      enable = true;
      extraConfig = ''
        Host renko
          HostName 192.168.64.3
          Port 62954
          User root
      '';
    };

    nix.buildMachines = [
      {
        hostName = "renko";
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
      ripgrep # rg, better grep!
      deadnix # dead-code scanner
      alejandra # code formatter
      statix # anti-pattern finder
      deploy-rs.deploy-rs # deployment system
      rnix-lsp # vscode nix extensions
      terraform # terraform
      kubectl # kubernetes
      k9s # cute k8s client, canines~
      kubernetes-helm # helm
      awscli
    ];

    home-manager.users.kat = {
      programs.zsh = {
        sessionVariables = {
          PYENV_ROOT = "$HOME/.pyenv";
          PATH = "$PYENV_ROOT/bin:$PATH";
          PIPENV_PYTHON = "$PYENV_ROOT/shims/python";
        };
        initExtra = ''
          plugin=(pyenv)
          eval $(pyenv init -)
          eval $(pyenv virtualenv-init -)
          source <(kubectl completion zsh)
        '';
        shellAliases = {
          artemiscli = "~/.artemis/.venv/bin/artemiscli";
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
      ];
      casks = [
        "utm"
        "barrier"
        "bitwarden"
        "firefox"
        "disk-inventory-x"
        "dozer"
        "devtoys"
        "cyberduck"
        "docker"
        "spotify"
        "pycharm-ce"
        "slack"
        "boop"
        "obsidian"
        "contexts"
        "rectangle"
        "keybase"
      ];
      taps = [
        "pulumi/tap"
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
