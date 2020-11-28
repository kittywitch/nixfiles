# nixfiles

Nix deployment related stuff.

## Related commands for usage

### SSH Problem solving

For new deploys, the SSHOPTS="-p 22" when // kat is applied to a SSH host definition will be required.

* export NIX_SSHOPTS="-p 62954"
* export NIX_SSHOPTS="-p 22"

### Deployment

* nix build -f . deploy.all && ./result
* nix build -f . deploy.\<group\> && ./result
* nix build -f . deploy.\<hostname\> && ./result

## Systems

* Beltane - Main server.
* Samhain - Desktop.
* Yule - Laptop.
* Litha - Netbook.
* Mabon - Thinkpad.

## To-do

- [ ] Secrets management for Beltane.
- [ ] Additional services configuration for Beltane
- [ ] Move Firefox configuration to be done using home-manager, maybe even going as far to NUR package things like 1password + tree style tabs(?)
- [ ] Move Samhain's two additional big drives to using ZFS, with an ext4 1TiB partition for the excess on the 3TiB drive.
- [ ] Move every desktop manager utilizing system to using Sway.
- [ ] Write a sway configuration. Maybe following [this](http://blog.patapon.info/nixos-systemd-sway/).
- [ ] Move Beltane to using ZFS.