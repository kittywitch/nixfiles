{ config, lib, ... }: with lib;

/*
  This hardware profile corresponds to the Lenovo IdeaPad v330-14ARR.
*/

{
  options.home-manager.users = let
    userTouchpadExtend = { config, nixos, ... }: {
      wayland.windowManager.sway.config.input."1739:33362:Synaptics_TM3336-002" = {
        dwt = "enabled";
        tap = "enabled";
        natural_scroll = "enabled";
        middle_emulation = "enabled";
        click_method = "clickfinger";
      };
    };
  in mkOption {
    type = types.attrsOf (types.submoduleWith {
      modules = singleton userTouchpadExtend;
    });
  };

  config = {
    deploy.profile.hardware.v330-14arr = true;

    boot.initrd.availableKernelModules =
      [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ ];
    boot.extraModulePackages = [ ];
  };
}
