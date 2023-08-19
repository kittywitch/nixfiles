{
  pkgs,
  inputs,
  lib,
  ...
}: {
  networking.firewall = {
    allowedTCPPorts = [25565 8123];
  };
  services.minecraft-servers = {
    enable = false;
    eula = false;
    environmentFile = pkgs.writeText "aaaa" ''
      QUILT_LOADER_DISABLE_BEACON=true
    '';
    servers.arkamew = let
      modpack = inputs.minecraft.legacyPackages.${pkgs.system}.fetchPackwizModpack {
        url = "https://github.com/kittywitch/arka-modpack/raw/main/pack.toml";
        packHash = "sha256-b198Q2eCf8xN3X6SJEIbFZB/PxC4vYcjiQSoeVjWyEk=";
        manifestHash = "sha256:17lg9syx1ddggyq2h8a92frg4lpr2xc7ryh30bniv9dhymr0vc23";
        side = "both";
      };
      mcVersion = modpack.manifest.versions.minecraft;
      quiltVersion = modpack.manifest.versions.quilt;
      serverVersion = lib.replaceStrings ["."] ["_"] "quilt-${mcVersion}-${quiltVersion}";
    in {
      enable = false;
      autoStart = true;
      openFirewall = true;
      whitelist = {
        katrynn = "356d8cf2-246a-4c07-b547-422aea06c0ab";
        arcnmx = "e9244315-848c-424a-b004-ae5305449fee";
      };
      jvmOpts = "-Xmx4G -Xms1G";
      serverProperties = {
        server-port = 25565;
        gamemode = 0;
        difficulty = 1;
        white-list = true;
        motd = "Kat & Abby Minecraft";
      };
      symlinks = {
        mods = "${modpack}/mods";
      };
      package = inputs.minecraft.legacyPackages.${pkgs.system}.quiltServers.${serverVersion};
    };
  };
}
