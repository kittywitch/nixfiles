{ sources, ... }: final: prev: {
  dns = import (sources.kirelagin + "/dns") { pkgs = final; };
}
