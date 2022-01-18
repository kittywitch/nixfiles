{ config, lib, pkgs, nixos, kw, ... }: with lib;

let
  commonSettings = {
    "app.update.auto" = false;
    "identity.fxaccounts.account.device.name" = nixos.networking.hostName;
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
    "browser.search.region" = "CA";
    "browser.search.suggest.enabled" = false;
    "browser.search.update" = false;
    "browser.selfsupport.url" = "";
    "extensions.getAddons.cache.enabled" = false;
    "extensions.pocket.enabled" = true;
    "geo.enabled" = false;
    "geo.wifi.uri" = false;
    "keyword.enabled" = false;
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
      ] ++ optional config.programs.buku.enable bukubrow;
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
  programs.firefox.tridactyl = let
      xsel = if config.deploy.profile.sway then "${pkgs.wl-clipboard}/bin/wl-copy" else "${pkgs.xsel}/bin/xsel";
      urxvt = "${pkgs.kitty}/bin/kitty";
      mpv = "${config.programs.mpv.finalPackage}/bin/mpv";
      vim = "${config.programs.neovim.package}/bin/nvim";
      firefox = "${config.programs.firefox.package}/bin/firefox";
    in {
      enable = true;
      sanitise = {
        local = true;
        sync = true;
      };
      themes = {
        custom = ''
          :root.TridactylThemeCustom {
              --tridactyl-hintspan-font-family: monospace, courier, sans-serif;
              --tridactyl-hintspan-font-size: 12px;
              --tridactyl-hintspan-fg: #fff;
              --tridactyl-hintspan-bg: #000088;
              --tridactyl-hintspan-border-color: #000;
              --tridactyl-hintspan-border-width: 1px;
              --tridactyl-hintspan-border-style: dashed;
              --tridactyl-hint-bg: #ffff99;
              --tridactyl-hint-outline: 1px dotted #000;
              --tridactyl-hint-active-bg: #00ff00;
              --tridactyl-hint-active-outline: 1px dotted #000;
          }
          :root.TridactylThemeCustom .TridactylHintElem {
              opacity: 0.3;
          }
          :root.TridactylThemeCustom span.TridactylHint {
              padding: 1px;
              margin-top: 8px;
              margin-left: -8px;
              opacity: 0.9;
              text-shadow: black -1px -1px 0px, black -1px 0px 0px, black -1px 1px 0px, black 1px -1px 0px, black 1px 0px 0px, black 1px 1px 0px, black 0px 1px 0px, black 0px -1px 0px !important;
          }
        '';
      };
      extraConfig = mkMerge [
        "colors default"
        "colors custom"

        (mkBefore ''jsb Promise.all(Object.keys(tri.config.get("searchurls")).forEach(u => tri.config.set("searchurls", u, "")))'')
        "jsb localStorage.fixedamo = true"
      ];

      autocmd = {
        docStart = [
          { urlPattern = ''^https:\/\/www\.reddit\.com''; cmd = ''js tri.excmds.urlmodify("-t", "www", "old")''; }
        ];
        tabEnter = [
          { urlPattern = ".*"; cmd = "unfocus"; } # alternative to `allowautofocus=false`
        ];
      };

      exalias = {
        wq = "qall";

        # whee clipboard stuff
        fn_getsel = ''jsb tri.native.run("${xsel} -op").then(r => r.content)'';
        fn_getclip = ''jsb tri.native.run("${xsel} -ob").then(r => r.content)'';
        fn_setsel = ''jsb -p tri.native.run("${xsel} -ip", JS_ARG)'';
        fn_setclip = ''jsb -p tri.native.run("${xsel} -ib", JS_ARG)'';

        fn_noempty = "jsb -p return JS_ARG";
      };

      bindings = [
        { key = ";y"; cmd = ''composite hint -pipe a[href]:not([display="none"]):not([href=""]) href | fn_setsel''; }
        { key = ";Y"; cmd = ''composite hint -pipe a[href]:not([display="none"]):not([href=""]) href | fn_setclip''; }
        { key = ";m"; cmd = ''composite hint -pipe a[href]:not([display="none"]):not([href=""]) href | shellescape | exclaim_quiet ${mpv}''; }
        { key = "F"; cmd = ''composite hint -t -c a[href]:not([display="none"]) href''; }
        # mpv --ontop --keepaspect-window --profile=protocol.http

        { mode = "hint"; key = "j"; mods = ["alt"]; cmd = "hint.focusBottomHint"; }
        { mode = "hint"; key = "k"; mods = ["alt"]; cmd = "hint.focusTopHint"; }
        { mode = "hint"; key = "h"; mods = ["alt"]; cmd = "hint.focusLeftHint"; }
        { mode = "hint"; key = "l"; mods = ["alt"]; cmd = "hint.focusRightHint"; }

        # Fix hints on google search results
        { urlPattern = ''www\.google\.com''; key = "f"; cmd = "hint -Jc .rc>.r>a"; }
        { urlPattern = ''www\.google\.com''; key = "F"; cmd = "hint -Jtc .rc>.r>a"; }

        # Comment toggler for Reddit and Hacker News
        { urlPattern = ''reddit\.com''; key = ";c"; cmd = ''hint -c [class*="expand"],[class="togg"]''; }

        # GitHub pull request checkout command to clipboard
        { key = "ygp"; cmd = ''composite js /^https?:\/\/github\.com\/([.0-9a-zA-Z_-]*\/[.0-9a-zA-Z_-]*)\/pull\/([0-9]*)/.exec(document.location.href) | js -p `git fetch https://github.com/''${JS_ARG[1]}.git pull/''${JS_ARG[2]}/head:pull-''${JS_ARG[2]} && git checkout pull-''${JS_ARG[2]}` | fn_setsel''; }

        # Git{Hub,Lab} git clone via SSH yank (NOTE: for https just... copy the url!)
        { key = "ygc"; cmd = ''composite js "git clone " + document.location.href.replace(/https?:\/\//,"git@").replace("/",":").replace(/$/,".git") | fn_setsel''; }

        # Git add remote (what if you want name to be upstream or something different? can I prompt via fillcmdline..?)
        { key = "ygr"; cmd = ''composite js /^https?:\/\/(github\.com|gitlab\.com)\/([.0-9a-zA-Z_-]*)\/([.0-9a-zA-Z_-]*)/.exec(document.location.href) | js -p `git remote add ''${JS_ARG[3]} https://''${JS_ARG[1]/''${JS_ARG[2]}/''${JS_ARG[3]}.git && git fetch ''${JS_ARG[3]}` | fn_setsel''; }

        # I like wikiwand but I don't like the way it changes URLs
        { urlPattern = ''wikiwand\.com''; key = "yy"; cmd = ''composite js document.location.href.replace("wikiwand.com/en","wikipedia.org/wiki") | fn_setsel''; }

        # attempt to maintain one tab per window:
        # bind F hint -w
        # bind T current_url winopen
        # bind t fillcmdline winopen

        { key = "r"; cmd = "reload"; }
        { key = "R"; cmd = "reloadhard"; }
        { key = "d"; cmd = "tabclose"; }

        { key = "``"; cmd = "tab #"; }

        { key = "j"; cmd = "scrollline 6"; }
        { key = "k"; cmd = "scrollline -6"; }

        { mode = ["normal" "input" "insert"]; key = "h"; mods = ["ctrl"]; cmd = "tabprev"; }
        { mode = ["normal" "input" "insert"]; key = "l"; mods = ["ctrl"]; cmd = "tabnext"; }
        { mode = ["normal" "input" "insert"]; key = "J"; mods = ["ctrl"]; cmd = "tabnext"; }
        { mode = ["normal" "input" "insert"]; key = "K"; mods = ["ctrl"]; cmd = "tabprev"; }
        # TODO: consider C-jk instead of C-hl?
        { mode = ["normal" "input" "insert"]; key = "k"; mods = ["ctrl"]; cmd = "tabmove -1"; }
        { mode = ["normal" "input" "insert"]; key = "j"; mods = ["ctrl"]; cmd = "tabmove +1"; }
        { key = "<Space>"; cmd = "scrollpage 0.75"; }
        { key = "f"; mods = ["ctrl"]; cmd = null; }
        { key = "b"; mods = ["ctrl"]; cmd = null; }
        { mode = "ex"; key = "a"; mods = ["ctrl"]; cmd = null; }

        # Make gu take you back to subreddit from comments
        { urlPattern = ''reddit\.com''; key = "gu"; cmd = "urlparent 3"; }

        # inpage find (not recommended for actual use)
        { key = "/"; mods = ["ctrl"]; cmd = "fillcmdline find"; }
        { key = "?"; cmd = "fillcmdline find -?"; }
        { key = "n"; cmd = "findnext 1"; }
        { key = "N"; cmd = "findnext -1"; }
        { key = ",<Space>"; cmd = "nohlsearch"; }

        { key = "gi"; cmd = "focusinput -l"; } # this should be 0 but it never seems to focus anything visible or useful?
        { key = "i"; cmd = "focusinput -l"; }
        { key = "I"; cmd = "mode ignore"; }
        { mode = "ignore"; key = "<Escape>"; mods = ["shift"]; cmd = "composite mode normal ; hidecmdline"; }

        { key = "<Insert>"; mods = ["shift"]; cmd = "composite fn_getsel | fillcmdline_notrail open"; }
        { key = "<Insert>"; mods = ["shift" "alt"]; cmd = "composite fn_getclip | fillcmdline_notrail open"; }
        { key = "C"; mods = ["shift" "alt"]; cmd = "composite fn_getsel | fn_setclip"; }
        { mode = ["ex" "input" "insert"]; key = "<Insert>"; mods = ["shift"]; cmd = "composite fn_getsel | text.insert_text"; }
        { mode = ["ex" "input" "insert"]; key = "<Insert>"; mods = ["shift" "alt"]; cmd = "composite fn_getclip | text.insert_text"; }
        { mode = ["ex" "input" "insert"]; key = "V"; mods = ["shift" "alt"]; cmd = "composite fn_getclip | text.insert_text"; }
        { mode = ["ex" "input" "insert"]; key = "C"; mods = ["shift" "alt"]; cmd = "composite fn_getsel | fn_setclip"; }

        { mode = ["insert" "input"]; key = "e"; mods = ["ctrl"]; cmd = "editor"; }

        { key = "<F1>"; cmd = null; }
      ];

      settings = {
        #allowautofocus = false;

        browser = firefox;

        editorcmd = ''${urxvt} -e ${vim} %f -c "normal %lG%cl"'';

        nag = false;
        leavegithubalone = false;
        newtabfocus = "page";
        # until empty newtab focus works...
        tabopencontaineraware = false;
        #storageloc = "local";
        #storageloc = "sync";
        hintuppercase = false;
        hintchars = "fdsqjklmrezauiopwxcvghtybn";
        #hintfiltermode = "vimperator-reflow";
        #hintnames = "numeric";
        modeindicator = true;
        modeindicatorshowkeys = true;
        autocontainmode = "relaxed";

        searchengine = "g";
        "searchurls.g" = "https://encrypted.google.com/search?q=%s";
        "searchurls.gh" = "https://github.com/search?q=%s";
        "searchurls.ghc" = "https://github.com/%s1/search?q=%s2";
        "searchurls.ghf" = "https://github.com/%s1/search?q=filename%3a%s2";
        "searchurls.ghp" = "https://github.com/%s1/pulls?q=%s2";
        "searchurls.ghi" = "https://github.com/%s1/issues?q=is%3aissue+%s2";
        "searchurls.gha" = "https://github.com/%s1/issues?q=%s2";
        "searchurls.w" = "https://en.wikipedia.org/wiki/Special:Search?search=%s";
        "searchurls.ddg" = "https://duckduckgo.com/?q=%s";
        "searchurls.r" = "https://reddit.com/r/%s";
        "searchurls.rs" = "https://doc.rust-lang.org/std/index.html?search=%s";
        "searchurls.crates" = "https://lib.rs/search?q=%s";
        "searchurls.docs" = "https://docs.rs/%s1/*/?search=%s2";
        "searchurls.nixos" = "https://search.nixos.org/options?channel=unstable&from=0&size=1000&sort=alpha_asc&query=%s";
        "searchurls.aur" = "https://aur.archlinux.org/packages/?K=%s";
        "searchurls.yt" = "https://www.youtube.com/results?search_query=%s";
        "searchurls.az" = "https://www.amazon.ca/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=%s";
        "searchurls.gw2" = "https://wiki.guildwars2.com/index.php?title=Special%3ASearch&search=%s&go=Go&ns0=1";
        "searchurls.gw2i" = "https://gw2efficiency.com/account/overview?filter.name=%s";
        "searchurls.gw2c" = "https://gw2efficiency.com/crafting/recipe-search?filter.orderBy=name&filter.search=%s";

        putfrom = "selection";
        # set yankto selection
        yankto = "both";
        externalclipboardcmd = xsel;
      };
      urlSettings = {
        allowautofocus = {
          "play\\.rust-lang\\.org" = { value = true; };
          "typescriptlang\\.org/play" = { value = true; };
        };
      };
    };
}
