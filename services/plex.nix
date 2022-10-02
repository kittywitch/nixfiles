{ config, nixfiles, pkgs, lib, ... }: {
    networks.chitei.tcp = [ 32400 ];
    services = {
    plex = {
      enable = true;
      package = pkgs.plex.overrideAttrs (x: let
        # see https://www.plex.tv/media-server-downloads/ for 64bit rpm
        version = "1.25.9.5721-965587f64";
        sha256 = "sha256-NPfpQ8JwXDaq8xpvSabyqdDqMWjoqbeoJdu41nhdsI0=";
      in {
        name = "plex-${version}";
        src = pkgs.fetchurl {
          url = "https://downloads.plex.tv/plex-media-server-new/${version}/debian/plexmediaserver_${version}_amd64.deb";
          inherit sha256;
        };
      }
      );
    };
  };
}
