{ config, pkgs, lib, sources, witch, ... }:

{
  /*
  # libvirtd is used for our virtual machine
  virtualisation.libvirtd = {
    enable = true;
    qemuOvmf = true;
    qemuRunAsRoot = false;
    onBoot = "ignore";
    onShutdown = "shutdown";
    };
  */

  # required for guest reboots with the 580
  boot.extraModulePackages = [
    (pkgs.linuxPackagesFor config.boot.kernelPackages.kernel).vendor-reset
  ]; # required groups for various intentions
  users.users.kat.extraGroups = [ "libvirtd" "input" "qemu-libvirtd" ];

  # video=efifb:off allows the 580 to be passed through regardless of being the boot display and allows the 560 to act as a console device
  # pci=noats means that it doesn't kernel panic on my specific configuration
  boot.kernelParams = [
    "amd_iommu=on"
    "pci=noats"
    "video=efifb:off"
  ]; # eventually switch to vfio-pci.ids to replace the boot.initrd.preDeviceCommands block
  boot.initrd.availableKernelModules =
    [ "amdgpu" "vfio-pci" ]; # vfio-pci is required for pci passthrough
  boot.kernelModules =
    [ "i2c-dev" "kvm-amd" ]; # i2c-dev is required for DDC/CI for screenstub

  # this section makes vfio-pci be injected as the driver for the 580 and its audio thingy
  # it should be replaced as mentioned with vfio-pci.ids
  # the script provided: https://alexbakker.me/post/nixos-pci-passthrough-qemu-vfio.html can be used to find iommu groups
  boot.initrd.preDeviceCommands = ''
    DEVS="0000:26:00.0 0000:26:00.1"
    for DEV in $DEVS; do
      echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    done
    modprobe -i vfio-pci
  '';

  # rules are for:
  # * monitor ddc/ci
  # * input for qemu
  # * rule for event-mouse (i hope?)
  # * uinput rule
  services.udev.extraRules = ''
    SUBSYSTEM=="i2c-dev", GROUP="users", MODE="0660"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="05ac", ATTRS{idProduct}=="12a8", GROUP="users"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="04d9", ATTRS{idProduct}=="fa58", GROUP="users"
    SUBSYSTEM=="usb", ACTION=="add", ATTRS{idVendor}=="fa58", ATTRS{idProduct}=="04d9", GROUP="users"
    SUBSYSTEM=="misc", KERNEL=="uinput", OPTIONS+="static_node=uinput", MODE="0660", GROUP="uinput"
    SUBSYSTEM=="vfio", OWNER="kat", GROUP="users"
    SUBSYSTEM=="block", ACTION=="add", ATTRS{model}=="HFS256G32TNF-N3A", ATTRS{wwid}=="t10.ATA     HFS256G32TNF-N3A0A                      MJ8BN15091150BM1Z   ", OWNER="kat"
    SUBSYSTEM=="block", ACTION=="add", ATTR{partition}=="2", ATTR{size}=="1953503232", ATTRS{wwid}=="naa.5000039fe6e8614e", OWNER="kat"
  '';

  environment.systemPackages = [
    # pkgs.nur.repos.arc.packages.screenstub # for DDC/CI and input forwarding (currently disabled due to using changed source)
    pkgs.arc.pkgs.scream-arc # for audio forwarding
    pkgs.screenstub # for input handling
    pkgs.ddcutil # for diagnostics on DDC/CI
    pkgs.kat-vm
  ];

  security.pam.loginLimits = [
      {
        domain = "@users";
        type = "-";
        item = "memlock";
        value = "unlimited";
      }
    ];

  systemd.extraConfig = "DefaultLimitMEMLOCK=infinity";

  /*
  systemd.services.libvirtd-guest-win10 = {
    enable = true;
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    serviceConfig = {
      type = "oneshot";
      RemainAfterExit = "yes";
    };
    script = let
      xml =
        pkgs.writeText "libvirt-guest-win10.xml" (import ./win10.xml.nix { });
    in ''
      uuid="$(${pkgs.libvirt}/bin/virsh domuuid 'win10' || true)"
      ${pkgs.libvirt}/bin/virsh define <(sed "s/UUID/$uuid/" '${xml}')
      ${pkgs.libvirt}/bin/virsh start 'win10';
    '';
    preStop = ''
      ${pkgs.libvirt}/bin/virsh shutdown 'win10'
      let "timeout = $(date +%s) + 120"
      while [ "$(${pkgs.libvirt}/bin/virsh list --name | grep --count '^win10$')" -gt 0 ]; do
        if [ "$(date +%s)" -ge "$timeout" ]; then
          # meh, we warned it...
          ${pkgs.libvirt}/bin/virsh destroy 'win10'
        else
          # the machine is still running, let's give it some time to shut down
          sleep 0.5
        fi
      done
    '';
  };
  */

  home-manager.users.kat = {
    # audio for vm on startup
    systemd.user.services = {
      scream = {
        Unit = { Description = "Scream - Audio forwarding from the VM."; };
        Service = {
          ExecStart =
            "${pkgs.arc.pkgs.scream-arc}/bin/scream -i virbr0 -o pulse";
          Restart = "always";
        };
        Install = { WantedBy = [ "default.target" ]; };
      };
    };
  };

  # BusId is used to specify the graphics card used for X / lightdm / wayland
  # BusId must be decimal conversion of the equivalent but matching the format, this was 0000:25:00.0
  services.xserver.deviceSection = lib.mkDefault ''
    Option "TearFree" "true"
    BusID "PCI:37:0:0"
  '';
}
