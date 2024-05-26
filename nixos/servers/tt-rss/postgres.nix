_: {
  services.postgresql = {
    ensureDatabases = ["tt_rss"];
    ensureUsers = [
      {
        name = "tt_rss";
        ensureDBOwnership = true;
      }
    ];
  };
}
