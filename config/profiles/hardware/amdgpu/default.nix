{ config, pkgs, ... }:

{
  deploy.profile.hardware.amdgpu = true;

  boot.initrd.availableKernelModules = [ "amdgpu" ];
  hardware.opengl.extraPackages = with pkgs; [ libvdpau-va-gl vaapiVdpau ];
}
