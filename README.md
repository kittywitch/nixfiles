# dotfiles

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
* Litha - Backup laptop.
* Ostara - HTPC laptop, maybe.

## To-do

- [ ] Integrate Ostara into configurations.
- [ ] Secrets management for Beltane.
- [ ] Additional services configuration for Beltane (that isn't )
- [ ] Migrate to something that isn't XFCE or GNOME for the laptop devices (likely Sway).
- [ ] Move Firefox configuration to be done using home-manager, maybe even going as far to NUR package things like 1password + tree style tabs(?)