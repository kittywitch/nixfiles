{
  pkgs,
  inputs,
  ...
}: {
  systemd.user.services.gw = {
    description = "Guild Wars";
    serviceConfig = {
      ExecStart = "${pkgs.katwine}/bin/katwine gw";
      Type = "simple";
    };
    environment = {
      PROTON_CACHYOS = "${inputs.chaotic.packages.${pkgs.system}.proton-cachyos_x86_64_v3.out}/bin";
      PROTON_GE = "${inputs.chaotic.packages.${pkgs.system}.proton-ge-custom.out}/bin";
    };
  };
  systemd.user.services.gw2 = {
    description = "Guild Wars 2";
    serviceConfig = {
      ExecStart = "${pkgs.katwine}/bin/katwine gw2";
      Type = "simple";
    };
    environment = {
      PROTON_CACHYOS = "${inputs.chaotic.packages.${pkgs.system}.proton-cachyos_x86_64_v3.out}/bin";
      PROTON_GE = "${inputs.chaotic.packages.${pkgs.system}.proton-ge-custom.out}/bin";
    };
  };
  systemd.user.services.battlenet = {
    description = "Battle.net";
    serviceConfig = {
      ExecStart = "${pkgs.katwine}/bin/katwine bnet";
      Type = "simple";
    };
    environment = {
      PROTON_CACHYOS = "${inputs.chaotic.packages.${pkgs.system}.proton-cachyos_x86_64_v3.out}/bin";
      PROTON_GE = "${inputs.chaotic.packages.${pkgs.system}.proton-ge-custom.out}/bin";
    };
  };
  systemd.user.services.sc = {
    description = "Starcraft";
    serviceConfig = {
      ExecStart = "${pkgs.katwine}/bin/katwine sc";
      Type = "simple";
    };
    environment = {
      PROTON_CACHYOS = "${inputs.chaotic.packages.${pkgs.system}.proton-cachyos_x86_64_v3.out}/bin";
      PROTON_GE = "${inputs.chaotic.packages.${pkgs.system}.proton-ge-custom.out}/bin";
    };
  };
  systemd.user.services.sc2 = {
    description = "Starcraft 2";
    serviceConfig = {
      ExecStart = "${pkgs.katwine}/bin/katwine sc2";
      Type = "simple";
    };
    environment = {
      PROTON_CACHYOS = "${inputs.chaotic.packages.${pkgs.system}.proton-cachyos_x86_64_v3.out}/bin";
      PROTON_GE = "${inputs.chaotic.packages.${pkgs.system}.proton-ge-custom.out}/bin";
    };
  };
  # https://lutris.net/games/install/25450/view
  # Dissection:
  # * nvapi disables,
  # * registry key for Win7 in version
  systemd.user.services.wc3 = {
    description = "Warcraft 3";
    serviceConfig = {
      ExecStart = "${pkgs.katwine}/bin/katwine wc3";
      Type = "simple";
    };
    environment = {
      PROTON_CACHYOS = "${inputs.chaotic.packages.${pkgs.system}.proton-cachyos_x86_64_v3.out}/bin";
      PROTON_GE = "${inputs.chaotic.packages.${pkgs.system}.proton-ge-custom.out}/bin";
      #PROTON_WC3 = "/home/kat/.local/share/Steam/compatibilitytools.d/GE-Proton10-1";
      #PROTON_WC3 = "/home/kat/.local/share/Steam/compatibilitytools.d/Proton-Tkg-2367";
      #PROTON_WC3 = "/home/kat/.local/share/Steam/steamapps/common/Proton - Experimental";
    };
  };
  systemd.user.services.kanon = {
    description = "Kanon";
    serviceConfig = {
      ExecStart = "${pkgs.katwine}/bin/katwine kanon";
      Type = "simple";
    };
  };
  systemd.user.services.hanahira = {
    description = "Hanahira";
    serviceConfig = {
      ExecStart = "${pkgs.katwine}/bin/katwine hanahira";
      Type = "simple";
    };
  };
}
