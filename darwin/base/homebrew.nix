{ config, ... }: {
  homebrew = {
    enable = true;
    cleanup = "zap";
    brews = [
      "mas"
    ];
  };
}
