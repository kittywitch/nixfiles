_: let
  hostConfig = {
    tree,
    modulesPath,
    ...
  }: {
    imports =
      [
        (modulesPath + "/profiles/qemu-guest.nix")
      ]
      ++ (with tree.nixos; [
        #container-host
        #microvm-host
      ])
      ++ (with tree.nixos.profiles; [
        server
      ])
      ++ (with tree.nixos.hardware; [
        oracle_flex
      ])
      ++ (with tree.nixos.servers; [
        weechat
        #matrix
        forgejo
        forgejo-runner
        postgres
        web
      ]);

    # TODO: Add config.microvm.stateDir to backup schedule?
    # TODO: figure out updateFlake?
    #microvm = {
    #  host.enable = true;
    #  vms = {
    #    syncthing = {
    #      autostart = true;
    #      specialArgs = removeAttrs specyArgs ["config" "pkgs" "lib"];
    #      config = {
    #        imports = [
    #          tree.nixos.servers.syncthing
    #        ];
    #        services = {
    #          syncthing = {
    #            enable = true;
    #          };
    #        };
    #      };
    #      restartIfChanged = true;
    #    };
    #  };
    #};

    system.stateVersion = "23.11";
  };
in {
  arch = "aarch64";
  type = "NixOS";
  deploy.hostname = "daiyousei.inskip.me";
  colmena.tags = [
    "server"
    "oci"
  ];
  modules = [
    hostConfig
  ];
}
