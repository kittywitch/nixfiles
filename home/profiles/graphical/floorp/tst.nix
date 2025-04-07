{ nur, ... }: {
  programs.floorp.profiles.main = {
    extensions = {
      packages = with nur.repos.rycee.firefox-addons; [
        tree-style-tab
        move-unloaded-tabs-for-tst
        tab-unload-for-tree-style-tab
        tst-bookmarks-subpanel
        tst-indent-line
        tst-tab-search
        tst-wheel-and-double
        tst-more-tree-commands
      ];
      settings = {
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
    userChrome = ''
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
}
