{ config, pkgs, meta, ... }: {
  imports = with meta; [
    services.dnscrypt-proxy
  ];

  environment.systemPackages = with pkgs; [
    lyx
    texlive.combined.scheme-full
  ];
}
