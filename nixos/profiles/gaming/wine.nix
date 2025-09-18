{pkgs, ...}: {
  systemd.user.services.kanon = {
    description = "Kanon";
    serviceConfig = {
      ExecStart = "${pkgs.katwine}/bin/katwine kanon";
      Type = "forking";
    };
  };
  systemd.user.services.hanahira = {
    description = "Hanahira";
    serviceConfig = {
      ExecStart = "${pkgs.katwine}/bin/katwine hanahira";
      Type = "forking";
    };
  };
}
