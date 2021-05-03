{ config, ... }:

{
  services.konawall = { enable = true; interval = "20m"; };
}
