{ config, ... }:

{
  kw.fw = {
    private.tcp.ports = [ 111 2049 ];
    public.tcp.ports = [ 111 2049 ];
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = "/mnt/zraw/media 192.168.1.0/24(rw) 200::/7(rw) 2a00:23c7:c597:7400::/56(rw)";

  services.nginx.virtualHosts = {
    "${config.networking.hostName}.${config.kw.dns.ygg_prefix}.${config.kw.dns.domain}".locations."/" = {
      alias = "/mnt/zraw/media/";
      extraConfig = "autoindex on;";
    };
    ${config.kw.dns.ipv4}.locations."/" = {
      alias = "/mnt/zraw/media/";
      extraConfig = "autoindex on;";
    };
  };
}
