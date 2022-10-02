{ config, pkgs, lib, ... }: {
  _module.args.pkgs = lib.mkDefault pkgs;
}
