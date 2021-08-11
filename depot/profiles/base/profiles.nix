{ config, lib, ... }:

with lib;

{
  options = {
    deploy.profile = {
      gui = mkEnableOption "Graphical System";
      vfio = mkEnableOption "VFIO";
      trusted = mkEnableOption "Trusted Submodule";
      hardware = {
        acs-override = mkEnableOption "ACS IOMMU Override";
        amdgpu = mkEnableOption "AMD GPU";
        hcloud-imperative = mkEnableOption "Imperative Hetzner Cloud Setup";
        intel = mkEnableOption "Intel CPU";
        laptop = mkEnableOption "Laptop";
        wifi = mkEnableOption "WiFi, home network";
        ryzen = mkEnableOption "AMD Ryzen CPU";
        ms-7b86 = mkEnableOption "MSI B450-A Pro Max";
        rm-310 = mkEnableOption "Intel DQ67OW";
        eeepc-1015pem = mkEnableOption "Asus Eee PC 1015PEM";
        v330-14arr = mkEnableOption "Lenovo Ideapad v330-14ARR";
      };
    };
    home-manager.users = mkOption {
      type = types.attrsOf (types.submoduleWith {
        modules = [
          ({ superConfig, ... }: {
            options.deploy.profile = {
              gui = mkEnableOption "Graphical System";
              vfio = mkEnableOption "VFIO";
              trusted = mkEnableOption "Trusted Submodule";
              hardware = {
                acs-override = mkEnableOption "ACS IOMMU Override";
                amdgpu = mkEnableOption "AMD GPU";
                hcloud-imperative = mkEnableOption "Imperative Hetzner Cloud Setup";
                intel = mkEnableOption "Intel CPU";
                laptop = mkEnableOption "Laptop";
                wifi = mkEnableOption "WiFi, home network";
                ryzen = mkEnableOption "AMD Ryzen CPU";
                ms-7b86 = mkEnableOption "MSI B450-A Pro Max";
                rm-310 = mkEnableOption "Intel DQ67OW";
                eeepc-1015pem = mkEnableOption "Asus Eee PC 1015PEM";
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
