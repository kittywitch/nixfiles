{
  lib,
  ...
}: let
  inherit (lib.types) submodule loaOf;
  inherit (lib.modules) mkDefault mkAfter;
  inherit (lib.options) mkOption;
in {
  options.security.pam.services = mkOption {
    type = loaOf (submodule {
      config.text = mkDefault (mkAfter "session required pam_keyinit.so force revoke");
    });
  };
  config = {
    boot = {
      supportedFilesystems = ["bcachefs"];
    };
  };
}
