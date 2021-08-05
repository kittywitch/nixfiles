{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ ntfs3g exfat-utils ];
}
