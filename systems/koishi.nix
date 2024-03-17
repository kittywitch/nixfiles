_: let
hostConfig = {
  tree,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports =
    (with tree.nixos.hardware; [
     framework
    ])
    ++ (with tree.nixos.profiles; [
        graphical
        gaming
        wireless
        laptop
        bcachefs
    ])
    ++ (with tree.nixos.environments; [
        hyprland
    ]);
  config = let
    inherit (lib.modules) mkForce;
  in {
    home-manager.users.kat.imports =
      (with tree.home.profiles; [
       graphical
       devops
      ])
      ++ (with tree.home.environments; [
          hyprland
      ]);

    environment.systemPackages = with pkgs; [
      parsec-bin
      sbctl
    ];
    services.avahi = {
      nssmdns = true;
      enable = true;
      ipv4 = true;
      ipv6 = true;
      publish = {
        enable = true;
        addresses = true;
        workstation = true;
      };
    };
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/861e8815-9327-4e49-915b-73a3b0bdfa25";
        fsType = "bcachefs";
      };
      "/boot" = {
        device = "/dev/disk/by-uuid/DD84-303D";
        fsType = "vfat";
      };
    };

    swapDevices = [
    {device = "/dev/disk/by-uuid/04bd322e-dca0-43b8-b588-cc0ef1b1488e";}
    ];

    boot = {
      supportedFilesystems = ["ntfs"];
      loader = {
        systemd-boot.enable = mkForce false;
      };
      lanzaboote = {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
    };

    networking = {
      useDHCP = false;
    };

    system.stateVersion = "24.05";
  };
};
in {
  arch = "x86_64";
  type = "NixOS";
  modules = [
    hostConfig
  ];
}
