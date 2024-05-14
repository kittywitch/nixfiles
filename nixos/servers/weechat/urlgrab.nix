{ pkgs, ... }: {
    home-manager.users.kat.programs.weechat.config.matrix.urlgrab.default.copycmd = "${pkgs.xclip}/bin/xclip -sel clipboard";
}
