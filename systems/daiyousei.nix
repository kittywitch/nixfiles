_: let
  hostConfig = {
    tree,
    config,
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
          #forgejo
          #forgejo-runner
        ntfy
        stream
        #navidrome
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

    services.nginx.virtualHosts = let
      vHost = {
        extraConfig = ''
          add_header Content-Type text/plain;
          return 200 "meep?";
        '';
      };
    in {
      ${config.networking.fqdn} = {
        enableACME = true;
        forceSSL = true;
        default = true;
      };
      "localhost" = vHost;
    };
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
