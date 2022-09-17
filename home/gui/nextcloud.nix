{ config, ... }: {
	services = {
		nextcloud-client.enable = true;
		gnome-keyring.enable = true;
	};
}
