{ config, lib, pkgs, superConfig, ... }:

let
  commonSettings = {
    "app.update.auto" = false;
    "identity.fxaccounts.account.device.name" = superConfig.networking.hostName;
    "signon.rememberSignons" = false;
    "browser.download.lastDir" = "/home/kat/downloads";
    "browser.urlbar.placeholderName" = "DuckDuckGo";
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  };
in {
  programs.zsh.shellAliases = {
    ff-pm = "firefox --ProfileManager";
    ff-main = "firefox -P main";
    ff-work = "firefox -P work";
    ff-lewd = "firefox -P lewd";
  };

  programs.firefox = {
    enable = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      pkgs.ff-sponsorblock
      auto-tab-discard
      bitwarden
      darkreader
      decentraleyes
      foxyproxy-standard
      google-search-link-fix
      https-everywhere
      #old-reddit-redirect # made unnecessary due to tridactylrc
      privacy-badger
      reddit-enhancement-suite
      refined-github
      stylus
      terms-of-service-didnt-read
      tree-style-tab
      tridactyl
      ublock-origin
      violentmonkey
    ];
    profiles = {
      main = {
        id = 0;
        isDefault = true;
        settings = commonSettings // {

        };
        userChrome = import ./userChrome.css.nix { profile = "main"; };
      };
      work = {
        id = 1;
        settings = commonSettings // {

        };
        userChrome = import ./userChrome.css.nix { profile = "work"; };
      };
      lewd = {
        id = 2;
        settings = commonSettings // {

        };
        userChrome = import ./userChrome.css.nix { profile = "lewd"; };
      };
    };
  };

  home.file.".config/tridactyl/tridactylrc".source = ./tridactylrc;
}
