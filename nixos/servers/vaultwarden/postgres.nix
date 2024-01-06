_: {
  services.postgresql = {
    ensureDatabases = ["bitwarden_rs"];
    ensureUsers = [
      {
        name = "bitwarden_rs";
        ensureDBOwnership = true;
      }
    ];
  };
}
