{ config, lib, meta, ... }:

with lib;

{
  options = {
    deploy.profile = {
      gui = mkEnableOption "Graphical System";
      vfio = mkEnableOption "VFIO";
      shared = mkEnableOption "Shared System";
      trusted = mkEnableOption "Trusted Submodule";
      light = mkEnableOption "Light mode";
      cross = {
        enable = mkEnableOption "cross/emulated compilation";
        aarch64 = mkOption {
          type = types.bool;
          default = false;
        };
        armv6l = mkOption {
          type = types.bool;
          default = false;
        };
        armv7l = mkOption {
          type = types.bool;
          default = false;
        };
      };
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
        raspi = mkEnableOption "Raspberry Pi 1 Model B+";
        oracle = {
          common = mkEnableOption "OCI";
          ubuntu = mkEnableOption "Canonical Ubuntu Base Image";
          oracle = mkEnableOption "Oracle Linux Base Image";
        };
        eeepc-1015pem = mkEnableOption "Asus Eee PC 1015PEM";
        v330-14arr = mkEnableOption "Lenovo Ideapad v330-14ARR";
        x270 = mkEnableOption "Lenovo Thinkpad x270";
      };
    };
    home-manager.users = mkOption {
      type = types.attrsOf (types.submoduleWith {
        modules = [
          ({ nixos, ... }: {
            options.deploy.profile = {
              gui = mkEnableOption "Graphical System";
              vfio = mkEnableOption "VFIO";
              shared = mkEnableOption "Shared System";
              trusted = mkEnableOption "Trusted Submodule" // {
                default = meta.trusted ? secrets;
              };
              light = mkEnableOption "Light mode";
              cross = {
                enable = mkEnableOption "cross/emulated compilation";
                aarch64 = mkOption {
                  type = types.bool;
                  default = false;
                };
                armv6l = mkOption {
                  type = types.bool;
                  default = false;
                };
                armv7l = mkOption {
                  type = types.bool;
                  default = false;
                };
              };
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
                raspi = mkEnableOption "Raspberry Pi 1 Model B+";
                oracle = {
                  common = mkEnableOption "OCI";
                  ubuntu = mkEnableOption "Canonical Ubuntu Base Image";
                  oracle = mkEnableOption "Oracle Linux Base Image";
                };
                eeepc-1015pem = mkEnableOption "Asus Eee PC 1015PEM";
                v330-14arr = mkEnableOption "Lenovo Ideapad v330-14ARR";
                x270 = mkEnableOption "Lenovo Thinkpad x270";
              };
            };
            config = {
              deploy.profile = nixos.deploy.profile;
            };
          })
        ];
      });
    };
  };
}
