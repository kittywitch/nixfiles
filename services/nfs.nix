{ config, lib, nixfiles, ... }:

with lib;

{
  networks.chitei = {
    tcp = [ 111 2049 ];
  };

  services.nfs.server.enable = true;
  # chitei, tailscale v4, link-local, tailscale v6
  services.nfs.server.exports = "/mnt/zraw/media 192.168.1.0/24(rw) 100.64.0.0/10(rw) fe80::/10(rw) fd7a:115c:a1e0:ab12::/64(rw)";
}

