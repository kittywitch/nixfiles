{ config, pkgs, ... }: {
	users.users.kat = {
		name = "kat";
		home = "/Users/kat";
		shell = pkgs.zsh;
                uid = 501;
	};
        users.knownUsers = [
		"kat"
	];
	home-manager.users.kat.programs.zsh.initExtraFirst = ''
		source /etc/static/zshrc
	'';
}
