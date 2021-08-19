{ config, lib, pkgs, ... }:

{
  config = {
    programs.notmuch = {
      enable = true;
      hooks = { preNew = "mbsync --all"; };
    };

    programs.mbsync.enable = true;
    programs.msmtp.enable = true;

    programs.vim.plugins = [ pkgs.vimPlugins.notmuch-vim ];

    accounts.email = {
      maildirBasePath = "${config.home.homeDirectory}/mail";
      accounts.kat = {
        address = "kat@kittywit.ch";
        primary = true;
        realName = "kat witch";
        userName = "kat@kittywit.ch";
        msmtp.enable = true;
        mbsync.enable = true;
        mbsync.create = "maildir";
        notmuch.enable = true;
        imap.host = "athame.kittywit.ch";
        smtp.host = "athame.kittywit.ch";
        passwordCommand = "${pkgs.pass}/bin/pass email/kittywitch";
        gpg = {
          signByDefault = true;
          key = "01F50A29D4AA91175A11BDB17248991EFA8EFBEE";
        };
      };
    };
  };
}
