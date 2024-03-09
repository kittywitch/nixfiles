_: {
  services.monica = {
    enable = true;
    appURL = "https://monica.gensokyo.zone";
    nginx = {
      serverName = "monica.gensokyo.zone";
    };
  };
}
