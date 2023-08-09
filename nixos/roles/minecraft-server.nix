{
  pkgs,
  inputs,
  lib,
  ...
}: {
  services.minecraft-servers = {
    enable = true;
    eula = true;
    environmentFile = pkgs.writeText "aaaa" ''
      QUILT_LOADER_DISABLE_BEACON=true
    '';
    servers.arkamew = let
      modpack = inputs.minecraft.legacyPackages.${pkgs.system}.fetchPackwizModpack {
        url = "https://github.com/kittywitch/arka-modpack/raw/main/pack.toml";
        packHash = "sha256-5JbJvoVd+YxAS+EIFsXHuG5ZqVGxEgf2AjQOLSuG99U=";
        manifestHash = "sha256:17lg9syx1ddggyq2h8a92frg4lpr2xc7ryh30bniv9dhymr0vc23";
        side = "both";
      };
      mcVersion = modpack.manifest.versions.minecraft;
      quiltVersion = modpack.manifest.versions.quilt;
      serverVersion = lib.replaceStrings ["."] ["_"] "quilt-${mcVersion}-${quiltVersion}";
    in {
      enable = true;
      autoStart = true;
      openFirewall = true;
      whitelist = {
        katrynn = "356d8cf2-246a-4c07-b547-422aea06c0ab";
        arcnmx = "e9244315-848c-424a-b004-ae5305449fee";
      };
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
