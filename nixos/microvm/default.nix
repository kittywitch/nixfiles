{
  config,
  lib,
  ...
}: let
  inherit (lib.modules) mkDefault;
  inherit (lib.meta) getExe';
in {
  # TODO: more
  microvm = {
    guest.enable = true;
    optimize.enable = true;
    vcpu = 2;
    mem = 2048;
    initialBalloonMem = 256;
    balloon = true;
    volumes = [
      {
        autoCreate = true;
        mountPoint = "/var";
        image = "var.img";
        size = 256;
      }
    ];
    shares = [
      {
        tag = "ro-store";
        source = "/nix/store";
        mountPoint = "/nix/.ro-store";
      }
    ];
  };

  boot = {
    loader.grub.enable = false;
    loader.systemd-boot.enable = false;
  };

  fileSystems = {
    "/" = mkDefault {
      fsType = "tmpfs";
    };
  };

  services.fstrim.enable = false;
  nix = {
    gc.automatic = false;
  };
  hardware.enableRedistributableFirmware = false;

  initrd.kernelModules = [
    # required for net.netfilter.nf_conntrack_max appearing in sysfs early at boot
    "nf_conntrack"
  ];
  kernel.sysctl = let
    limit = 2 * 1024;
    mem =
      if (config?microvm)
      then config.microvm.mem
      else limit;
  in
    lib.optionalAttrs (mem <= limit) {
      # table overflow causing packets from nginx to the service to drop
      # nf_conntrack: nf_conntrack: table full, dropping packet
      "net.netfilter.nf_conntrack_max" = lib.mkDefault "65536";
    };
  kernelParams = [
    # mitigations which cost the most performance and are the least real world relevant
    # NOTE: keep in sync with baremetal.nix
    "retbleed=off"
    "gather_data_sampling=off" # Downfall
  ];

  system.build.installBootLoader = getExe' pkgs.coreutils "true";

  systemd.tmpfiles.rules = [
    "d /home/root 0700 root root -" # createHome does not create it
  ];

  users = {
    mutableUsers = false;
    # store root users files persistent, especially .bash_history
    users."root" = {
      createHome = true;
      home = lib.mkForce "/home/root";
    };
  };
}
