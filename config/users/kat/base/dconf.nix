{ config, lib, ... }: {
  dconf.enable = lib.mkDefault false; # TODO: is this just broken? # yes, yes it fucking is
}
