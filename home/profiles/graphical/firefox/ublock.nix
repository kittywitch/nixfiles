{nur, ...}: {
  programs.zen-browser.profiles.main.extensions = {
    packages = with nur.repos.rycee.firefox-addons; [
      ublock-origin
    ];
    settings = {
      "uBlock@raymondhill.net".settings = {
        selectedFilterLists = [
          "user-filters"
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-quick-fixes"
          "ublock-unbreak"
          "easylist"
          "adguard-generic"
          "adguard-mobile"
          "easyprivacy"
          "adguard-spyware"
          "adguard-spyware-url"
          "urlhaus-1"
          "plowe-0"
          "fanboy-cookiemonster"
          "ublock-cookies-easylist"
          "adguard-cookies"
          "ublock-cookies-adguard"
          "fanboy-social"
          "adguard-social"
          "easylist-chat"
          "easylist-newsletters"
          "easylist-notifications"
          "easylist-annoyances"
          "adguard-mobile-app-banners"
          "adguard-other-annoyances"
          "adguard-popup-overlays"
          "adguard-widgets"
          "ublock-annoyances"
        ];
      };
    };
  };
}
