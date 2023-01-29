_: let
  super = "Mod4";
in {
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = super;
      fonts = [ ];
    };

    bars = [
    ];
  };
}
