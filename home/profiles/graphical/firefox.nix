{pkgs, nur, ...}: let
  defaultFont = "Monaspace Krypton";
in {
  home.sessionVariables = {
    BROWSER = "firefox";
  };

  home.packages = [ pkgs.ff2mpv-rust ];
  programs.firefox = {
    nativeMessagingHosts = [
      pkgs.ff2mpv-rust
    ];
    enable = true;
    profiles = {
      main = {
        id = 0;
        isDefault = true;
        containers = {
          main = {
            name = "Main";
            id = 0;
            color = "turquoise";
            icon = "pet";
          };
          gay = {
            name = "Gay";
            id = 1;
            color = "purple";
            icon = "pet";
          };
          work = {
            name = "Work";
            id = 2;
            color = "pink";
            icon = "briefcase";
          };
          banking = {
            name = "Banking";
            id = 3;
            color = "turquoise";
          };
        };
        containersForce = true;
        extensions = {
          packages = with nur.repos.rycee.firefox-addons; [
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
            tree-style-tab
            move-unloaded-tabs-for-tst
            tab-unload-for-tree-style-tab
            tst-bookmarks-subpanel
            tst-indent-line
            tst-tab-search
            tst-wheel-and-double
            tst-more-tree-commands
            reddit-enhancement-suite
            refined-github
            stylus
            temporary-containers
            multi-account-containers
            dearrow
            ublock-origin
            betterttv
            violentmonkey
            return-youtube-dislikes
            ff2mpv
          ];
          force = true;
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
            "treestyletab@piro.sakura.ne.jp".settings = {
              cachedExternalAddons = [
                "tst-active-tab-on-scrollbar@piro.sakura.ne.jp"
                "tst-indent-line@piro.sakura.ne.jp"
              ];
              faviconizePinnedTabs = false;
              lastSelectedSubPanelProviderId = "tst-bookmarks-subpanel@piro.sakura.ne.jp";
              showExpertOptions = true;
              skipCollapsedTabsForTabSwitchingShortcuts = true;
              tabPreviewTooltip = true;
            };
          };
        };
        settings = {
          # Stylin'
          font = {
            default = {
              x-western = defaultFont;
              x-unicode = defaultFont;
            };
          };
          # Derived from https://github.com/arcnmx/home/blob/9eb1cd4dd43883e1a0c6a2a55c00d7c3bede1776/cfg/firefox/default.nix#L7
          # and https://git.ztn.sh/zotan/snowleopard/src/branch/dev/assets/prefs.js
          "services.sync.engine.prefs" = false;
          "services.sync.engine.prefs.modified" = false;
          "services.sync.engine.passwords" = false;
          "services.sync.declinedEngines" = "passwords,adblockplus,prefs";
          "media.eme.enabled" = true; # whee drm
          "gfx.webrender.all.qualified" = true;
          "gfx.webrender.all" = true;
          "webgl.enable-draft-extensions" = true;
          "layers.acceleration.force-enabled" = true;
          "gfx.canvas.azure.accelerated" = true;
          "browser.ctrlTab.recentlyUsedOrder" = false;
          "privacy.resistFingerprinting.block_mozAddonManager" = true;
          "extensions.webextensions.restrictedDomains" = "";
          "browser.shell.checkDefaultBrowser" = false;
          "spellchecker.dictionary" = "en-CA";
          "ui.context_menus.after_mouseup" = true;
          "browser.warnOnQuit" = false;
          "browser.quitShortcut.disabled" = true;
          "browser.startup.homepage" = "about:blank";
          "browser.contentblocking.category" = "strict";
          "browser.discovery.enabled" = false;
          "browser.tabs.multiselect" = true;
          "browser.tabs.remote.separatedMozillaDomains" = "";
          "browser.tabs.remote.separatePrivilegedContentProcess" = false;
          "browser.tabs.remote.separatePrivilegedMozillaWebContentProcess" = false;
          "browser.tabs.unloadOnLowMemory" = true;
          "browser.tabs.closeWindowWithLastTab" = false;
          "browser.newtab.privateAllowed" = true;
          "browser.newtabpage.enabled" = false;
          "browser.urlbar.placeholderName" = "";
          "extensions.privatebrowsing.notification" = false;
          "browser.startup.page" = 3;
          "devtools.chrome.enabled" = true;
          #"devtools.debugger.remote-enabled" = true;
          "devtools.inspector.showUserAgentStyles" = true;
          "services.sync.prefs.sync.privacy.donottrackheader.value" = false;
          "services.sync.prefs.sync.browser.safebrowsing.malware.enabled" = false;
          "services.sync.prefs.sync.browser.safebrowsing.phishing.enabled" = false;
          "app.shield.optoutstudies.enabled" = true;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "datareporting.sessions.current.clean" = true;
          "devtools.onboarding.telemetry.logged" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.hybridContent.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.reportingpolicy.firstRun" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.server" = "";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.coverage.opt-out" = true;
          "toolkit.coverage.enabled" = false;
          "toolkit.coverage.endpoint.base" = "";
          "toolkit.crashreporter.infoURL" = "";
          "browser.onboarding.enabled" = false;
          "experiments.enabled" = false;
          "network.allow-experiments" = false;
          "social.directories" = "";
          "social.remote-install.enabled" = false;
          "social.toast-notifications.enabled" = false;
          "social.whitelist" = "";
          "browser.safebrowsing.malware.enabled" = false;
          "browser.safebrowsing.blockedURIs.enabled" = false;
          "browser.safebrowsing.downloads.enabled" = false;
          "browser.safebrowsing.downloads.remote.enabled" = false;
          "browser.safebrowsing.phishing.enabled" = false;
          "dom.ipc.plugins.reportCrashURL" = false;
          "breakpad.reportURL" = "";
          "beacon.enabled" = false;
          "browser.search.geoip.url" = "";
          "browser.search.region" = "CA";
          "browser.search.suggest.enabled" = true;
          "browser.search.update" = false;
          "browser.selfsupport.url" = "";
          "extensions.getAddons.cache.enabled" = false;
          "extensions.pocket.enabled" = false;
          "geo.enabled" = false;
          "geo.wifi.uri" = false;
          "keyword.enabled" = true;
          "media.getusermedia.screensharing.enabled" = false;
          "media.video_stats.enabled" = false;
          "device.sensors.enabled" = false;
          "dom.battery.enabled" = false;
          "dom.enable_performance" = false;
          "network.dns.disablePrefetch" = false;
          "network.http.speculative-parallel-limit" = 8;
          "network.predictor.cleaned-up" = true;
          "network.predictor.enabled" = true;
          "network.prefetch-next" = true;
          "security.dialog_enable_delay" = 300;
          "dom.event.contextmenu.enabled" = true;
          "reader.parse-on-load.enabled" = false;
          "media.webspeech.synth.enabled" = false;
          "privacy.trackingprotection.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;
          "privacy.trackingprotection.cryptomining.enabled" = true;
          "privacy.trackingprotection.introCount" = 20;
          "signon.rememberSignons" = false;
          "xpinstall.whitelist.required" = false;
          "xpinstall.signatures.required" = false;
          "general.smoothScroll" = false;
          "general.warnOnAboutConfig" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
        userChrome = ''
          #urlbar {
            font-family: "${defaultFont}", monospace;
          }
          /* Hide horizontal tabs at the top of the window */
          #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar {
            opacity: 0;
            pointer-events: none;
          }
          #main-window #TabsToolbar {
              visibility: collapse !important;
          }
          /* Hide the "Tree Style Tab" header at the top of the sidebar */
          #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
            display: none;
          }
        '';
      };
    };
  };
}
