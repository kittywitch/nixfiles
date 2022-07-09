{ config, lib, ... }: with lib; {
  options.kw.secrets.command = mkOption {
    type = types.str;
  };
}
