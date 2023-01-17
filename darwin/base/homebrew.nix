_: {
  homebrew = {
    enable = true;
    onActivation = {
      upgrade = true;
      cleanup = "zap";
    };
    brews = [
      "mas"
    ];
  };
}
