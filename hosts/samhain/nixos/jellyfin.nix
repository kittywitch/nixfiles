{ config, lib, pkgs, ... }:

{
  kw.fw.public.tcp.ranges = [{
    from = 32768;
    to = 60999;
  }];

  kw.fw.private.tcp.ranges = [{
    from = 32768;
    to = 60999;
  }];

  services.jellyfin.enable = true;
}
