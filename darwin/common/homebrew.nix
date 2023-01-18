_: {
  homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      cleanup = "uninstall";
    };
    brews = [
      "mas"
    ];
  };
}
