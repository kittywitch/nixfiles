{
  config,
  ...
}: {
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 180;
        command = "${config.programs.swaylock.package}/bin/swaylock* -f";
      }
      {
        timeout = 600;
        command = "${config.programs.niri.package}/bin/niri msg action power-off-monitors";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${config.programs.swaylock.package}/bin/swaylock* -f";
      }
    ];
  };
}
