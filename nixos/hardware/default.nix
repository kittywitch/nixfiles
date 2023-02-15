{ lib, tree, ... }: with lib; let
  profiles = tree.prev;
  appendedProfiles = {
    common-wifi-bt = {
      imports = with profiles; [
        wifi
        bluetooth
      ];
    };
    laptop = {
      imports = with profiles; [
        laptop
        sound
      ];
    };
    lenovo-thinkpad-x260 = {
      imports = with profiles; [
        lenovo-thinkpad-x260
        lenovo-thinkpad-x260-local
        appendedProfiles.laptop
        appendedProfiles.common-wifi-bt
      ];
    };
  };
in
profiles // appendedProfiles
