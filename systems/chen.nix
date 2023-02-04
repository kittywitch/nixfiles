_: let
  hostConfig = {lib, tree, modulesPath, inputs, pkgs, ...}: let
    inherit (lib.modules) mkForce;
  in {
    imports = with tree; [
      inputs.wsl.nixosModules.wsl
    ];

    networking.firewall.enable = mkForce false;

    boot.kernel.sysctl = mkForce {};

    systemd.services = {
      systemd-sysctl.enable = false;
    };

    fileSystems = {
      "/" = {
        device = "/dev/sdc";
        fsType = "ext4";
      };
      "/usr/lib/wsl/drivers" = {
        device = "drivers";
        fsType = "9p";
      };
      "/usr/lib/wsl/lib" = {
        device = "none";
        fsType = "overlay";
      };
      "/mnt/wsl" = {
        device = "none";
        fsType = "tmpfs";
      };
      "/mnt/wslg" = {
        device = "none";
        fsType = "tmpfs";
      };
      "/mnt/wslg/doc" = {
        device = "none";
        fsType = "overlay";
      };
      "/mnt/c" = {
        device = "drvfs";
        fsType = "9p";
      };
    };

    swapDevices = [
      { device = "/dev/sdb"; }
    ];

    wsl = {
      enable = true;
      defaultUser = "kat";
      startMenuLaunchers = true;
      nativeSystemd = true;
      wslConf.automount.root = "/mnt";
    };

    networking = {
      hostId = "dddbb888";
      useDHCP = false;
    };

    system.stateVersion = "22.05";
  };
in {
  arch = "x86_64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
