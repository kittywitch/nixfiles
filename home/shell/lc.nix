{ config, ... }: {
  home.language = let
    ca = "en_CA.UTF-8";
    gb = "en_GB.UTF-8";
    dk = "en_DK.UTF-8";
  in {
    base = ca;
    ctype = ca;
    time = dk;
    numeric = ca;
    collate = ca;
    monetary = ca;
    messages = ca;
    paper = gb;
    name = gb;
    address = ca;
    telephone = ca;
    measurement = ca;
  };
}
