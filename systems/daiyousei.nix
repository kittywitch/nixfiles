_: let
  hostConfig = {
    pkgs,
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
        ntfy
        postgres
        web
      ]);

    environment.systemPackages = [
      pkgs.numix-icon-theme
    ];

    networking.firewall.allowedTCPPorts = [
      1935
    ];
    systemd.services.nginx.serviceConfig.BindPaths = [
      "/var/www/streamy"
    ];
    services.nginx = let
      streamyHome = "/var/www/streamy";
    in {
      virtualHosts."stream.kittywit.ch" = {
        enableACME = true;
        forceSSL = true;
        acmeRoot = null;
        locations = {
          "/" = {
            root = streamyHome;
          };
        };
      };
      appendConfig = ''
        rtmp {
          server {
            listen 1935;
            chunk_size 4096;
            application animu {
              allow publish 100.64.0.0/10;
              deny publish all;

              live on;
              record off;
              hls on;
              hls_path ${streamyHome}/hls;
              hls_fragment 3;
              hls_playlist_length 60;

              dash on;
              dash_path ${streamyHome}/dash;
            }
          }
        }
      '';
    };

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
