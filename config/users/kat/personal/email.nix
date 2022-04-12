{ config, lib, pkgs, ... }:

{
  config = {
    programs = {
      notmuch = {
        enable = true;
        hooks = { preNew = "mbsync --all"; };
      };

      mbsync.enable = true;
      msmtp.enable = true;
      vim.plugins = [ pkgs.vimPlugins.notmuch-vim ];
      neovim.plugins = [ pkgs.vimPlugins.notmuch-vim ];
    };

    services.imapnotify.enable = false;

    accounts.email = {
      maildirBasePath = "${config.home.homeDirectory}/mail";
      accounts.kat = {
        address = "kat@kittywit.ch";
        primary = true;
        realName = "kat witch";
        userName = "kat@kittywit.ch";
        msmtp.enable = true;
        mbsync = {
          enable = true;
          create = "maildir";
        };
        notmuch.enable = true;
        imapnotify = {
          enable = true;
          boxes = [ "Inbox" ];
          onNotifyPost = "${pkgs.notmuch}/bin/notmuch new && ${pkgs.libnotify}/bin/notify-send 'New mail arrived'";
        };
        imap.host = "daiyousei.kittywit.ch";
        smtp.host = "daiyousei.kittywit.ch";
        passwordCommand = "bitw get services/kittywitch -f password";
        gpg = {
          signByDefault = true;
          key = "01F50A29D4AA91175A11BDB17248991EFA8EFBEE";
        };
      };
    };
  };
}
