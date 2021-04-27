{ config, lib, pkgs, witch, ... }:

{
  katnet.public.tcp.ranges = [{
    from = 32768;
    to = 60999;
  }];

  katnet.private.tcp.ranges = [{
    from = 32768;
    to = 60999;
  }];

  services.jellyfin.enable = true;
}
