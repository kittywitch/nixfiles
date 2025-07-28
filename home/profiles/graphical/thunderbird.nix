_: {
  programs.thunderbird = {
    enable = true;
    profiles.main = {
      isDefault = true;
      withExternalGnupg = true;
    };
  };
  accounts.email.accounts = let
      katIdentity = {
        realName = "Kat Inskip";
      };
      dorkIdentity = {
        realName = "Kat Dork";
      };
      mainEnable.thunderbird = {
        enable = true;
        profiles = [ "main" ];
      };
      gmailAccount = mainEnable // {
        flavor = "gmail.com";
      };
    in {
    primary = gmailAccount // katIdentity // {
      primary = true;
      address = "kat@inskip.me";
    };
    home = gmailAccount // katIdentity // {
      address = "kat.inskip@gmail.com";
    };
    dork = gmailAccount // dorkIdentity // {
      address = "dorkdev99@gmail.com";
    };
  };

}
