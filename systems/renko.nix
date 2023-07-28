_: let
  hostConfig = {
    lib,
    tree,
    pkgs,
    inputs,
    ...
  }: let
    inherit (lib.modules) mkDefault mkForce;
  in {
    imports = [
      "${inputs.nixpkgs}/nixos/modules/virtualisation/lxc-container.nix"
    ];

    nix.extraOptions = "extra-platforms = x86_64-linux i686-linux";

    networking = {
      nftables.enable = mkForce false;
      firewall.enable = mkForce false;
      useDHCP = false;
      interfaces.eth0.useDHCP = true;
    };

    nixpkgs.hostPlatform = mkDefault "aarch64-linux";

    boot.kernelPackages = pkgs.linuxPackages_6_3;

    environment.systemPackages = with pkgs; [
      inputs.artemiscli.packages.aarch64-linux.artemiscli
      awscli2
      kubectl
    ];

    system.stateVersion = "22.11";

    security.sudo.extraRules = [
      {
        users = ["kat"];
        commands = [
          {
            command = "ALL";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];

    # add OrbStack CLI tools to PATH
    environment.shellInit = ''
      . /opt/orbstack-guest/etc/profile-early

      # add your customizations here

      . /opt/orbstack-guest/etc/profile-late
    '';

    # faster DHCP - OrbStack uses SLAAC exclusively
    networking.dhcpcd.extraConfig = ''
      noarp
      noipv6
    '';

    # disable sshd
    services.openssh.enable = true;

    # systemd
    systemd.services."systemd-oomd".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-resolved".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-userdbd".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-udevd".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-timesyncd".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-timedated".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-portabled".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-nspawn@".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-networkd".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-machined".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-localed".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-logind".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-journald@".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-journald".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-journal-remote".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-journal-upload".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-importd".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-hostnamed".serviceConfig.WatchdogSec = 0;
    systemd.services."systemd-homed".serviceConfig.WatchdogSec = 0;

    # package installation: not needed

    # ssh config
    programs.ssh.extraConfig = ''
      Include /opt/orbstack-guest/etc/ssh_config
    '';

    # extra certificates
    security.pki.certificateFiles = [
      "/opt/orbstack-guest/run/extra-certs.crt"
    ];
  };
in {
  arch = "aarch64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
