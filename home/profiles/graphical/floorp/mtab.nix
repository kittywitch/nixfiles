{ nur, ... }: {
  programs.floorp.profiles.main.extensions = {
    packages = with nur.repos.rycee.firefox-addons; [
      mtab
    ];
    settings."contact@maxhu.dev".settings = {
      config = {
        animations = {
          bookmarkTiming = "left";
          bookmarkType = "animate-page-up";
          enabled = true;
          initialType = "animate-up-bouncy";
          searchType = "animate-page-shrink";
        };
        bookmarks = {
          bookmarksLocationFirefox = "toolbar";
          defaultBlockyColor = "#ffffff";
          defaultBlockyColorType = "custom";
          defaultBlockyCols = 4;
          defaultFaviconSource = "duckduckgo";
          defaultFolderIconType = "ri-folder-fill";
          lineOrientation = "top";
          numberKeys = false;
          showBookmarkNames = true;
          type = "default-blocky";
          userDefined = [
          ];
          userDefinedCols = null;
        };
        extras = {
          snow = { enabled = "off"; };
        };
        hotkeys = {
          activationKey = " ";
          closePageKey = "x";
          enabled = true;
          searchBookmarksKey = "b";
        };
        message = {
          customText = "your custom text";
          enabled = false;
          font = {
            custom = "";
            type = "default";
          };
          textColor = "#ffffff";
          textSize = 3.75;
          type = "afternoon-morning";
          weather = { unitsType = "f"; };
        };
        options = { showOptionsButton = true; };
        search = {
          assist = {
            conversions = true;
            date = true;
            definitions = true;
            math = true;
          };
          bookmarkIconColor = "#3b82f6";
          bookmarkPlaceholderText = "find bookmark...";
          customEngineURL = "";
          enabled = true;
          engine = "duckduckgo";
          focusedBorderColor = "#0ea5e9";
          font = {
            custom = "";
            type = "default";
          };
          placeholderText = "search...";
          placeholderTextColor = "#a1a1aa";
          searchIconColor = "#14b8a6";
          selectIconColor = "#f59e0b";
          textColor = "#ffffff";
          useCustomEngine = false;
        };
        title = {
          defaultTitle = "mtab";
          dynamic = { enabled = true; };
          faviconType = "default";
        };
        ui = {
          backgroundColor = "#171717";
          blurStrength = "32px";
          cornerStyle = "round";
          customCSS = ''
            .top-distance {
              top: 0vh !important;
            }
          '';
          foregroundColor = "#262626";
          glassColor = "#ffffff20";
          highlightColor = "#ffffff20";
          style = "glass";
        };
        user = { name = "kat"; };
        wallpaper = {
          enabled = false;
          filters = {
            blur = "0px";
            brightness = "1";
          };
          type = "url";
          url = "./wallpapers/default.png";
        };
      };
      optionsData = {
        sectionsExpanded = {
          animations = true;
          bookmarks = true;
          extras = true;
          hotkeys = true;
          message = true;
          options = true;
          search = true;
          title = true;
          ui = true;
          user = true;
          wallpaper = true;
        };
      };
    };
  };
}
