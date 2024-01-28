{pkgs, ...}: {
  systemd.services.fanSetup = let
    # https://github.com/arcnmx/home/blob/9eb1cd4dd43883e1a0c6a2a55c00d7c3bede1776/hw/x370gpc/default.nix#L80 <3
    nct = "/sys/devices/platform/nct6775.656/hwmon/hwmon*/";
    # https://www.kernel.org/doc/html/next/hwmon/nct6775.html
    #nct = ".//.//.sys.devices.platform.nct6775/656.hwmon.hwmon0";

    # take in celcius, turn it into millicelcius
    tempIn = x: toString (x * 1000);
    # take in a percentage, turn it into a number between 0 and 255
    pwmIn = x: toString (x * 255 / 100);

    pwmEnable = {
      maximum = 0;
      manual = 1;
      thermalCruise = 2;
      speedCruise = 3;
      # smart_fan_3 = 4;
      smart_fan = 5;
    };

    cpu_sensor = 2;
    mobo_sensor = 3;

    cpu_temp = "temp${toString cpu_sensor}";
    mobo_temp = "temp${toString mobo_sensor}";
    exhaust = "pwm1";
    intake = "pwm3";

    temps = {
      cpu = {
        max = 80;
        max_hyst = 75;
      };

      mobo = {
        max = 50;
        max_hyst = 45;
      };
    };

    fanScript = pkgs.writeShellScriptBin "fan" ''
      cd ${nct}
      echo "${toString temps.cpu.max}" > ${cpu_temp}_max
      echo "${toString temps.cpu.max_hyst}" > ${cpu_temp}_max_hyst
      echo "${toString temps.mobo.max}" > ${mobo_temp}_max
      echo "${toString temps.mobo.max_hyst}" > ${mobo_temp}_max_hyst

      # Rear and Top Exhaust

      echo "${toString pwmEnable.smart_fan}" > ${exhaust}_enable
      echo "${toString mobo_sensor}" > ${exhaust}_temp_sel
      echo "${tempIn 35}" > ${exhaust}_auto_point1_temp
      echo "${pwmIn 10}" > ${exhaust}_auto_point1_pwm
      echo "${tempIn 40}" > ${exhaust}_auto_point2_temp
      echo "${pwmIn 20}" > ${exhaust}_auto_point2_pwm
      echo "${tempIn 45}" > ${exhaust}_auto_point3_temp
      echo "${pwmIn 50}" > ${exhaust}_auto_point3_pwm
      echo "${tempIn 50}" > ${exhaust}_auto_point4_temp
      echo "${pwmIn 75}" > ${exhaust}_auto_point4_pwm
      echo "${tempIn 55}" > ${exhaust}_auto_point5_temp
      echo "${pwmIn 100}" > ${exhaust}_auto_point5_pwm

      # Bottom Intake

      echo "${toString pwmEnable.smart_fan}" > ${intake}_enable
      echo "${toString mobo_sensor}" > ${intake}_temp_sel
      echo "${tempIn 35}" > ${intake}_auto_point1_temp
      echo "${pwmIn 10}" > ${intake}_auto_point1_pwm
      echo "${tempIn 40}" > ${intake}_auto_point2_temp
      echo "${pwmIn 20}" > ${intake}_auto_point2_pwm
      echo "${tempIn 45}" > ${intake}_auto_point3_temp
      echo "${pwmIn 50}" > ${intake}_auto_point3_pwm
      echo "${tempIn 50}" > ${intake}_auto_point4_temp
      echo "${pwmIn 75}" > ${intake}_auto_point4_pwm
      echo "${tempIn 55}" > ${intake}_auto_point5_temp
      echo "${pwmIn 100}" > ${intake}_auto_point5_pwm

      # CLC
      ${pkgs.liquidctl}/bin/liquidctl --match clc set fan speed 20 0 30 0 40 10 50 50 60 75 70 100
    '';
  in {
    wantedBy = ["multi-user.target" "sleep.target"];
    description = "Set up the fan speeds for the system";
    after = ["systemd-modules-load.service" "suspend.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${fanScript}/bin/fan";
    };
  };
}
