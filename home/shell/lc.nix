{ config, ... }: {
  home.language = let
    ca = "en_CA.UTF-8";
    dk = "en_DK.UTF-8";
  in {
    base = ca;
    ctype = ca;
    time = ca;
    numeric = ca;
    collate = ca;
    monetary = ca;
    messages = ca;
    paper = ca;
    name = ca;
    address = ca;
    telephone = ca;
    measurement = ca;
  };
}
