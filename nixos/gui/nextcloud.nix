{ config, ... }: {
	services.gnome = {
		gnome-keyring.enable = true;
	};
	security.pam.services.lightdm.enableGnomeKeyring = true;
	programs.seahorse.enable = true;
}
