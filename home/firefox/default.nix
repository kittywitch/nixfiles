{ config, lib, pkgs, nixos, kw, ... }:

let
  inherit (lib.strings) toLower;
  commonSettings = {
    "app.update.auto" = false;
    "identity.fxaccounts.account.device.name" = "${nixos.networking.hostName}-${toLower pkgs.hostPlatform.uname.system}";
    "browser.download.lastDir" = "/home/kat/downloads";
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "svg.context-properties.content.enabled" = true;
    "services.sync.engine.prefs" = false;
    "services.sync.engine.prefs.modified" = false;
    "services.sync.engine.passwords" = false;
    "services.sync.declinedEngines" = "passwords,adblockplus,prefs";
    "media.eme.enabled" = true; # whee drm
    "gfx.webrender.all.qualified" = true;
    "gfx.webrender.all" = true;
    "layers.acceleration.force-enabled" = true;
    "gfx.canvas.azure.accelerated" = true;
    "browser.ctrlTab.recentlyUsedOrder" = false;
    "privacy.resistFingerprinting.block_mozAddonManager" = true;
    "extensions.webextensions.restrictedDomains" = "";
    "tridactyl.unfixedamo" = true;
    "tridactyl.unfixedamo_removed" = true;
    "browser.shell.checkDefaultBrowser" = false;
    "spellchecker.dictionary" = "en-CA";
    "ui.context_menus.after_mouseup" = true;
    "browser.warnOnQuit" = false;
    "browser.quitShortcut.disabled" = true;
    "browser.startup.homepage" = "about:blank";
    "browser.contentblocking.category" = "strict";
    "browser.discovery.enabled" = false;
    "browser.tabs.multiselect" = true;
    "browser.tabs.unloadOnLowMemory" = true;
    "browser.newtab.privateAllowed" = true;
    "browser.newtabpage.enabled" = false;
    "browser.urlbar.placeholderName" = "";
    "extensions.privatebrowsing.notification" = false;
    "browser.startup.page" = 3;
    "devtools.chrome.enabled" = true;
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
    "browser.search.region" = "UK";
    "browser.search.suggest.enabled" = true;
    "browser.search.update" = false;
    "browser.selfsupport.url" = "";
    "extensions.getAddons.cache.enabled" = false;
    "extensions.pocket.enabled" = true;
    "geo.enabled" = false;
    "geo.wifi.uri" = false;
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
    "dom.event.contextmenu.enabled" = false;
    "privacy.trackingprotection.enabled" = true;
    "privacy.trackingprotection.fingerprinting.enabled" = true;
    "privacy.trackingprotection.cryptomining.enabled" = true;
    "privacy.trackingprotection.introCount" = 20;
    "signon.rememberSignons" = false;
    "xpinstall.whitelist.required" = false;
    "xpinstall.signatures.required" = false;
    "general.warnOnAboutConfig" = false;
  };
in
{
  home.file.".mozilla/tst.css" = { inherit (kw.sassTemplate { name = "tst"; src = ./tst.sass; }) source; };

  programs.zsh.shellAliases = {
    ff-pm = "firefox --ProfileManager";
    ff-main = "firefox -P main";
  };

  home.sessionVariables = {
    XDG_CURRENT_DESKTOP = "sway";
  };

  programs.firefox = {
    enable = true;
    packageUnwrapped = pkgs.firefox-unwrapped;
    wrapperConfig = {
      extraPolicies = {
        DisableAppUpdate = true;
      };
      extraNativeMessagingHosts = with pkgs; [
        tridactyl-native
      ] ++ lib.optional config.programs.buku.enable bukubrow;
    };
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      sponsorblock
      link-cleaner
      a11ycss
      canvasblocker
      view-image
      wappalyzer
      auto-tab-discard
      bitwarden
      darkreader
      decentraleyes
      foxyproxy-standard
      clearurls
      df-youtube
      tridactyl
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
        containers.identities = [
          { id = 7; name = "Professional"; icon = "briefcase"; color = "red"; }
          { id = 8; name = "Shopping"; icon = "cart"; color = "pink"; }
          { id = 9; name = "Sensitive"; icon = "gift"; color = "orange"; }
          { id = 10; name = "Private"; icon = "fence"; color = "blue"; }
        ];
      };
    };
  };
}
