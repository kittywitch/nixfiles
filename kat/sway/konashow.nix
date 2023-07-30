{config, ...}: {
  home.packages = [
    config.services.konawall.konashow
  ];

  services.konawall = {
    enable = true;
    interval = "30m";
    mode = "shuffle";
    commonTags = ["width:>=1600"];
    tagList = [
      "score:>=50"
      #"no_humans"
      "rating:s"
    ];
  };
}
