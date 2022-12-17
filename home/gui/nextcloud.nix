{ config, ... }: {
	services = {
		nextcloud-client.enable = false;
		gnome-keyring.enable = false;
	};
}
