{pkgs, ...}: {
  stylix.targets.vesktop.enable = false;
  programs.nixcord = {
    enable = true;
    equibop.enable = true;
    config = {
      frameless = true;
      plugins = {
        # Shared
        betterFolders = {
          enable = true;
        };
        callTimer = {
          enable = true;
        };
        dearrow = {
          enable = true;
        };
        fakeNitro = {
          enable = true;
        };
        forceOwnerCrown.enable = true;
        gameActivityToggle.enable = true;
        memberCount.enable = true;
        mentionAvatars.enable = true;
        messageLatency.enable = true;
        messageTags = {
          enable = true;
          clyde = false;
          tagsList = {
          };
        };
        mutualGroupDMs.enable = true;
        pinDMs.enable = true;
        platformIndicators = {
          enable = true;
        };
        relationshipNotifier.enable = true;
        spotifyCrack.enable = true;
        typingIndicator.enable = true;
        userMessagesPronouns.enable = true;
        vcNarrator = {
          enable = true;
          volume = 0.5;
        };
        viewIcons.enable = true;
        youtubeAdblock.enable = true;
        # Equicord
        amITyping.enable = true;
        anammox = {
          enable = true;
          billing = true;
          dms = true;
          gift = true;
          serverBoost = true;
        };
        betterUserArea = {
          enable = true;
        };
        channelTabs.enable = true;
        equicordToolbox.enable = true;
        globalBadges.enable = true;
        moreKaomoji.enable = true;
        noNitroUpsell.enable = true;
        recentDmSwitcher.enable = true;
        statusPresets = {
          enable = true;
          statusPresets = {
          };
        };
      };
    };
  };
}
