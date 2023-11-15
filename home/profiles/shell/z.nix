{
  config,
  pkgs,
  ...
}: {
  # ensure .local/share/z is created
  xdg.dataFile."z/.keep".text = "";

  programs.zsh = {
    localVariables = {
      _Z_DATA = "${config.xdg.dataHome}/z/data";
    };
    plugins =
      map (plugin: (with pkgs.${plugin}; {
        name = pname;
        inherit src;
      })) [
        "zsh-z"
      ];
  };
}
