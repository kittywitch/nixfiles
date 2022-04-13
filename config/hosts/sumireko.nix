{ config, pkgs, lib, meta, ... }: {
  imports = with meta; [
      profiles.darwin
      users.kat.darwin
      users.kat.dev
  ];
  services.nix-daemon.enable = true;
  nix = {
    extraOptions = ''
     experimental-features = nix-command flakes
    '';
    package = pkgs.nixFlakes;
  };
  homebrew = {
    enable = true;
    brewPrefix = "/opt/homebrew/bin";
    casks = [
      "element"
      "visual-studio-code"
    ];
  };
  environment.systemPackages = with pkgs; [
    awscli
    jq
  ];

  programs.zsh = {
    enable = true;
  };

  system.stateVersion = 4;
}
