{ config, ... }:

{
  deploy.targets.infra = {
    nodeNames = [ "athame" ];
  };
}
