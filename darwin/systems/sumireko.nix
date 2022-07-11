{ config, pkgs, lib, inputs, meta, ... }: {
  imports = with meta; [
    hardware.aarch64-darwin
    darwin.base
    darwin.kat
  ];
  
  security.pam.enableSudoTouchIdAuth = true;

  homebrew = {
    brewPrefix = "/opt/homebrew/bin";
    casks = [
      "element"
      "visual-studio-code"
      "firefox"
      "telegram"
      "discord"
      "utm"
      "mullvadvpn"
      "bitwarden"
    ];
    masApps = {
      Tailscale = 1475387142;
    };
  };

  environment.systemPackages = with pkgs; [
    terraform
    yt-dlp
    k2tf
    awscli
    jq
  ];

  system.stateVersion = 4;
}
