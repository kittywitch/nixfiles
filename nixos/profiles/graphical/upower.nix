{pkgs, ...}: {
  services.upower = {
    enable = true;
  };
  environment.systemPackages = [
    pkgs.acpi
  ];
}
