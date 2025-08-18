{
  pkgs,
  nur,
  ...
}: {
  home.sessionVariables = {
    BROWSER = "zen";
  };
  stylix.targets.zen-browser.profileNames = ["main"];
  home.packages = [pkgs.ff2mpv-rust];
  programs.zen-browser = {
    nativeMessagingHosts = [
      pkgs.ff2mpv-rust
    ];
    enable = true;
    profiles = {
      main = {
        id = 0;
        isDefault = true;
        containersForce = true;
        extensions = {
          packages = with nur.repos.rycee.firefox-addons; [
            display-_anchors
            pronoundb
            sponsorblock
            link-cleaner
            canvasblocker
            a11ycss
            view-image
            wappalyzer
            auto-tab-discard
            bitwarden
            darkreader
            decentraleyes
            clearurls
            df-youtube
            old-reddit-redirect
            privacy-badger
            reddit-enhancement-suite
            refined-github
            stylus
            temporary-containers
            multi-account-containers
            dearrow
            betterttv
            violentmonkey
            return-youtube-dislikes
            ff2mpv
            terms-of-service-didnt-read
            web-clipper-obsidian
          ];
          force = true;
        };
      };
    };
  };
}
