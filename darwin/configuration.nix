{ config, pkgs, lib, ... }: {
  services.nix-daemon.enable = true;
  nix = {
    extraOptions = ''
     experimental-features = nix-command flakes
    '';
    package = pkgs.nixFlakes;
  };
  environment.systemPackages = with pkgs; [
	awscli
  ];
  system.stateVersion = 4;
}
