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
      profiles = ["main"];
    };
    gmailAccount =
      mainEnable
      // {
        flavor = "gmail.com";
      };
  in {
    main =
      mainEnable
      // katIdentity
      // {
        flavor = "plain";
        userName = "kat@dork.dev";
        address = "kat@dork.dev";
        imap = {
          tls.enable = true;
          host = "rinnosuke.inskip.me";
          port = 993;
        };
        smtp = {
          tls.enable = true;
          host = "rinnosuke.inskip.me";
          port = 465;
        };
      };
    primary =
      gmailAccount
      // katIdentity
      // {
        primary = true;
        address = "kat@inskip.me";
      };
    home =
      gmailAccount
      // katIdentity
      // {
        address = "kat.inskip@gmail.com";
      };
    dork =
      gmailAccount
      // dorkIdentity
      // {
        address = "dorkdev99@gmail.com";
      };
  };
}
