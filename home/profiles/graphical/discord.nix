{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (discord-krisp.override {
      withOpenASAR = true;
      withMoonlight = true;
    })
  ];

  programs.moonlight-mod = {
    enable = true;
  };
}
