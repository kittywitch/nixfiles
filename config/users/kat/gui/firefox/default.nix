{ config, lib, pkgs, nixos, kw, ... }:

let
  commonSettings = {
    "app.update.auto" = false;
    "identity.fxaccounts.account.device.name" = nixos.networking.hostName;
    "signon.rememberSignons" = false;
    "browser.download.lastDir" = "/home/kat/downloads";
    "browser.urlbar.placeholderName" = "DuckDuckGo";
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "svg.context-properties.content.enabled" = true;
    "extensions.pocket.enabled" = false;
  };
in
{
  home.file.".mozilla/tst.css" = { inherit (kw.sassTemplate { name = "tst"; src = ./tst.sass; }) source; };

  programs.zsh.shellAliases = {
    ff-pm = "firefox --ProfileManager";
    ff-main = "firefox -P main";
  };

  programs.browserpass = {
    enable = true;
    browsers = [ "firefox" ];
  };

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
  };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      sponsorblock
      floccus
      link-cleaner
      betterttv
      canvasblocker
      view-image
      pkgs.nur.repos.crazazy.firefox-addons.new-tab-override
      wappalyzer
      auto-tab-discard
      bitwarden
      darkreader
      decentraleyes
      foxyproxy-standard
      clearurls
      df-youtube
      old-reddit-redirect
      privacy-badger
      reddit-enhancement-suite
      refined-github
      stylus
      temporary-containers
      browserpass
      tree-style-tab
      multi-account-containers
      ublock-origin
      violentmonkey
    ];
    profiles = {
      main = {
        id = 0;
        isDefault = true;
        settings = commonSettings;
        userChrome = (kw.sassTemplate { name = "userChrome"; src = ./userChrome.sass; }).text;
      };
    };
  };
}
