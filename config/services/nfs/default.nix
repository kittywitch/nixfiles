{ config, lib, kw, ... }:

with lib;

{
  imports = optional config.deploy.profile.trusted (singleton config.kw.repoSecrets.nfs.source);

  network.firewall = {
    private.tcp.ports = [ 111 2049 ];
    public.tcp.ports = [ 111 2049 ];
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = "/mnt/zraw/media 192.168.1.0/24(rw) 200::/7(rw) 2a00:23c7:c597:7400::/56(rw)";

  services.nginx.virtualHosts = kw.virtualHostGen {
    networkFilter = [ "private" "yggdrasil" ];
    block.locations."/" = {
      alias = "/mnt/zraw/media/";
      extraConfig = "autoindex on;";
    };
  };
}
