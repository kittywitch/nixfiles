{ config, pkgs, lib, meta, ... }: {
  _module.args.pkgs = lib.mkDefault meta.pkgs;
}
