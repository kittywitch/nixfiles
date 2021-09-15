{ config, lib, ... }:

with lib;

{
  services.konawall = {
    enable = true;
    interval = "30m";
    mode = "shuffle";
    commonTags = [ "width:>=1600" ];
    tagList = map (toList) [
      "score:>=50"
      "touhou"
    ];
  };
}
