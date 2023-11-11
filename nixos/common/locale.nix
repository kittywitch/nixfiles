{pkgs, ...}: {
  fonts.packages = [
    pkgs.tamzen
  ];
  i18n = {
    defaultLocale = "en_CA.UTF-8";
    supportedLocales = [
      "en_CA.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "en_DK.UTF-8/UTF-8"
    ];
  };
  console = {
    packages = [pkgs.tamzen];
    font = "Tamzen7x14";
    earlySetup = true;
    keyMap = "uk";
  };
}
