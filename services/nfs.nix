{ config, lib, kw, ... }:

with lib;

{
  networks.chitei = {
    tcp = [ 111 2049 ];
  };

  services.nfs.server.enable = true;
  services.nfs.server.exports = "/mnt/zraw/media 192.168.1.0/24(rw) fe80::/10(rw) 200::/7(rw) 2a00:23c7:c597:7400::/56(rw)";
}

