{ lib, ... }:

{
  imports = [ ./home ];

  options = { deploy.profile.gui = lib.mkEnableOption "graphical system" // { default = true; }; };
}
