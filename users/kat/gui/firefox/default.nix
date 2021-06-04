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
in
{
  programs.zsh.shellAliases = {
    ff-pm = "firefox --ProfileManager";
    ff-main = "firefox -P main";
  };

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      sponsorblock
      auto-tab-discard
      bitwarden
      darkreader
      decentraleyes
      foxyproxy-standard
      clearurls
      bypass-paywalls
      df-youtube
      https-everywhere
      old-reddit-redirect
      privacy-badger
      reddit-enhancement-suite
      refined-github
      stylus
      terms-of-service-didnt-read
      #tree-style-tab
      sidebery
      ublock-origin
      violentmonkey
    ];
    profiles = {
      main = {
        id = 0;
        isDefault = true;
        settings = commonSettings // { };
        userChrome = import ./userChrome.css.nix { profile = "main"; };
      };
    };
  };
}
