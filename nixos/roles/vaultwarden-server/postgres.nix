_: {
  services.postgresql = {
    ensureDatabases = ["bitwarden_rs"];
    ensureUsers = [
      {
        name = "bitwarden_rs";
        ensurePermissions = {"DATABASE bitwarden_rs" = "ALL PRIVILEGES";};
      }
    ];
  };
}
