{ config, ... }:

{
  xdg.configFile."rbw/config.json".text = builtins.toJSON { 
    email = "kat@kittywit.ch"; 
    base_url = "https://vault.kittywit.ch";
    identity_url = null;
    lock_timeout = 3600;
  };
}
