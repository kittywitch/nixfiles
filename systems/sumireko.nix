_: let
  hostConfig = {tree, ...}: {
    imports = with tree.darwin; [
      orbstack
      packages
    ];

    home-manager.users.kat.imports =
      (with tree.home.profiles; [
        graphical.gpg
        graphical.vscode
        graphical.wezterm
      ])
      ++ (with tree.home.profiles; [
        devops
      ])
      ++ (with tree.home.environments; [
        darwin
      ]);

    system.stateVersion = 4;
  };
in {
  arch = "aarch64";
  type = "MacOS";
  modules = [
    hostConfig
  ];
}
