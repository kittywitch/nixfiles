{
  pkgs,
  inputs,
  lib,
  ...
}: let
  inherit (lib.meta) getExe;
  inherit (lib.attrsets) mapAttrs;
  environment = {
    PROTON_CACHYOS = "${inputs.chaotic.packages.${pkgs.system}.proton-cachyos_x86_64_v3.out}/bin";
    PROTON_GE = "${inputs.chaotic.packages.${pkgs.system}.proton-ge-custom.out}/bin";
  };
  games = {
    #
    # Proton / contemporary video games
    #

    gw = "Guild Wars";
    gw2 = "Guild Wars 2";
    battlenet = "Battle.net";
    sc = "Starcraft: Remastered";
    sc2 = "Starcraft 2";

    wcr = "Warcraft: Remastered";
    wc2r = "Warcraft 2: Remastered";
    wc = "Warcraft Orcs & Humans";
    wc2 = "Warcraft 2: Battle.net Edition";
    # https://lutris.net/games/install/25450/view
    # Dissection:
    # * nvapi disables,
    # * registry key for Win7 in version
    wc3 = "Warcraft 3: Reforged";

    #
    # Visual Novels
    #

    hanahira = "Hanahira";
    kanon = "Kanon";
  };
in {
  hardware.graphics = {
    enable32Bit = true;
    extraPackages32 = with pkgs; [
      driversi686Linux.mesa
    ];
  };
  programs.gamescope = {
    enable = true;
    package = pkgs.gamescope;
  };
  environment.systemPackages = with pkgs; [
    gamescope-wsi
    mangohud
    vkbasalt
  ];
  systemd.user.services =
    mapAttrs (k: v: {
      description = v;
      serviceConfig = {
        ExecStart = "${getExe pkgs.katwine} ${k}";
        Type = "simple";
      };
      inherit environment;
    })
    games;

  home-manager.users.kat.home.file = {
    # https://learnjapanese.moe/vn-linux/
    "Games/VNs/drive_c/script.bat".source = ./vn_script.bat;
    "Games/VNs/drive_c/cmd.exe".source = ./reactos_cmd.exe;
  };
}
