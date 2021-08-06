{ config, pkgs, ... }:

{
  services.znc = {
    enable = true;
    mutable = false;
    useLegacyConfig = false;
    openFirewall = false;
    modulePackages = with pkgs.zncModules; [
      clientbuffer
      clientaway
    ];
  };
}
