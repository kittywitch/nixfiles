{pkgs, ...}: {
  services.xserver.desktopManager.runXdgAutostartIfNone = true;
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-anthy
        fcitx5-gtk # TODO: Broken: 2025-10-28
      ];
    };
  };
}
