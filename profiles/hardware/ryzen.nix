{ config, pkgs, lib, ... }: with lib; {
/*
  This hardware profile corresponds to any machine which has an AMD Ryzen processor.
*/

  options.home-manager.users = let
    waybarExtend = { config, ... }: {
      options = {
        programs.waybar.settings = mkOption {
          type = with types; listOf (submodule waybarExtend2);
        };
      };
    };
    waybarExtend2 = { config, ... }: {
      config = {
        modules."temperature#icon".hwmon-path = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp2_input";
        modules.temperature.hwmon-path = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp2_input";
      };
    };
    polybarExtend = { config, ... }: {
      services.polybar.settings."module/temp".hwmon-path = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp1_input";
    };
    /*
    polybarExtend2 = { config, ... }: {
      config = {
        modules."temperature#icon".hwmon-path = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp2_input";
        modules.temperature.hwmon-path = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon2/temp2_input";
      };
    };*/
  in mkOption {
    type = types.attrsOf (types.submoduleWith {
      modules = [ waybarExtend polybarExtend ];
    });
  };

  config = {
    deploy.profile.hardware.ryzen = true;

    boot = {
      kernelModules = [
        "msr"
        "ryzen_smu"
        "kvm-amd"
      ];
      kernelParams = [ "amd_iommu=on" ];
    };

    hardware.cpu.amd.updateMicrocode = true;

    environment.systemPackages = with pkgs; [
      lm_sensors
      ryzen-smu-monitor_cpu
      ryzen-monitor
    ];
  };
}
