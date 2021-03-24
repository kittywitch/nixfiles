{ config, lib, pkgs, ... }:

{
  config = lib.mkIf config.deploy.profile.gui {
    programs.notmuch = {
      enable = true;
      hooks = { preNew = "mbsync --all"; };
    };
    programs.mbsync.enable = true;
    programs.msmtp.enable = true;
    accounts.email = {
      maildirBasePath = "${config.home.homeDirectory}/mail";
      accounts.kat = {
        address = "kat@kittywit.ch";
        primary = true;
        realName = "kat witch";
        userName = "kat@kittywit.ch";
        passwordCommand = ''
          ${pkgs.arc.pkgs.rbw-bitw}/bin/bitw -p gpg://${
            ../../../private/files/bitw/master.gpg
          } get "kittywitch email"'';
        msmtp.enable = true;
        mbsync.enable = true;
        mbsync.create = "maildir";
        notmuch.enable = true;
        imap.host = "kittywit.ch";
        smtp.host = "kittywit.ch";
        gpg = {
          signByDefault = true;
          key = "01F50A29D4AA91175A11BDB17248991EFA8EFBEE";
        };
      };
    };
    programs.vim.plugins = [ pkgs.arc.pkgs.vimPlugins.notmuch-vim ];
  };
}
