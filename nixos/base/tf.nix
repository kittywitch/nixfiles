{ config, ... }: {
  secrets = {
    root = "/var/lib/kat/secrets";
    persistentRoot = "/var/lib/kat/secrets";
    external = true;
  };
}
