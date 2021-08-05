{ config, lib, ... }:

with lib;

{
  options = {
    deploy.profile = {
      gui = mkEnableOption "Graphical System";
      laptop = mkEnableOption "Laptop (Implies WiFi)";
      vfio = mkEnableOption "VFIO";
      trusted = mkEnableOption "Trusted Submodule";
      hardware = {
        amdgpu = mkEnableOption "AMD GPU";
        hcloud-imperative = mkEnableOption "Imperative Hetzner Cloud Setup";
        intel = mkEnableOption "Intel CPU";
        ms-7b86 = mkEnableOption "MSI B450-A Pro Max";
        rm-310 = mkEnableOption "Intel DQ67OW";
        ryzen = mkEnableOption "AMD Ryzen CPU";
        v330-14arr = mkEnableOption "Lenovo Ideapad v330-14ARR";
      };
    };
    home-manager.users = mkOption {
      type = types.attrsOf (types.submoduleWith {
        modules = [
          ({ superConfig, ... }: {
            options.deploy.profile = {
              gui = mkEnableOption "Graphical System";
              laptop = mkEnableOption "Laptop (Implies WiFi)";
              vfio = mkEnableOption "VFIO";
              trusted = mkEnableOption "Trusted Submodule";
              hardware = {
                amdgpu = mkEnableOption "AMD GPU";
                hcloud-imperative = mkEnableOption "Imperative Hetzner Cloud Setup";
                intel = mkEnableOption "Intel CPU";
                ms-7b86 = mkEnableOption "MSI B450-A Pro Max";
                rm-310 = mkEnableOption "Intel DQ67OW";
                ryzen = mkEnableOption "AMD Ryzen CPU";
                v330-14arr = mkEnableOption "Lenovo Ideapad v330-14ARR";
              };
            };
            config = {
              deploy.profile = superConfig.deploy.profile;
            };
          })
        ];
      });
    };
  };
}
