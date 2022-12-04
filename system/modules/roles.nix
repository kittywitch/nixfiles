{ config, lib, ... }: let
  inherit (lib.options) mkOption mdDoc;
  inherit (lib.types) bool;
in {
  options = {
    role = {
      server = mkOption {
        type = bool;
        description = mdDoc "Is this system's role as a server?";
        default = false;
      };
      personal = mkOption {
        type = bool;
        description = mdDoc "Is this system's role as a personal device?";
        default = false;
      };
      development = mkOption {
        type = bool;
        description = mdDoc "Is this system's role as a development device?";
        default = false;
      };
      laptop = mkOption {
        type = bool;
        description = mdDoc "Is this system's role as a laptop?";
        default = false;
      };
      gnome = mkOption {
        type = bool;
        description = mdDoc "Does this system's role include running GNOME?";
        default = false;
      };
    };
  };
}
