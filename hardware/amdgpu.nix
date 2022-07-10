{ config, pkgs, lib, ... }:

with lib;

{
  boot.initrd.availableKernelModules = [ "amdgpu" ];
  hardware.opengl.extraPackages = with pkgs; [ libvdpau-va-gl vaapiVdpau ];
}
