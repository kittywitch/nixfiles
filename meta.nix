{ pkgs, lib, ... }: {
  config = {
    runners = {
      lazy = {
        file = ./.;
        args = [ "--show-trace" ];
      };
    };
    _module.args = {
      pkgs = lib.mkDefault pkgs;
    };
  };
}
