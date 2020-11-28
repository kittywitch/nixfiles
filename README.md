# nixfiles

Nix deployment related stuff.

## How to use

* Change SSH port for ./result's SSH connection to 62954 `export NIX_SSHOPTS="-p 62954"`
* Change SSH port for ./result's SSH connection to 22: `export NIX_SSHOPTS="-p 22"`
* Build all devices and execute the resulting deploy script: `nix build -f . deploy.all && ./result`
* Build all devices in \<group\> and execute the resulting deploy script:  `nix build -f . deploy.\<group\> && ./result`
* Build \<hostname\> and execute the resulting deploy script: `nix build -f . deploy.\<hostname\> && ./result`

## Hosts

* beltane - Hetzner VPS.
* samhain - Desktop.
* yule - Laptop.
* litha - Relatively unused netbook.
* mabon - Relatively unused Thinkpad t61p.

## To-do

### Overall
- [ ] DNS provider migration. (Cloudflare -> Glauca)
  - [ ] Fancy wildcard certificate shenanigans?

### Host: beltane
- [ ] Reinstall with a ZFS root filesystem.
  - [ ] Backup data from current install.
- [ ] Secrets management for Beltane.
- [ ] Additional services configuration for Beltane
  - [ ] matrix-synapse
  - [ ] matrix-puppet-discord
  - [ ] mautrix-whatsapp
  - [ ] mautrix-telegram
  - [ ] Nextcloud
  - [ ] bitwarden_rs

### Host: samhain
- [ ] Filesystems revamp for redundancy and media server usage.
  - [ ] Format "BigExtfs" as an encrypted, perhaps compressed ZFS pool.
  - [ ] Migrate the content from "BigEXT" over to the new ZFS pool.
  - [ ] Format "BigEXT" to be the mirror of the drive formerly known as "BigExtfs".
  - [ ] Excess space on the 3TiB drive should be formatted as either exFAT or ext4.
  - [ ] Work out any remaining quirks of this.

### Group: graphical
- [ ] Move all devices to using Sway. 
  - [ ] Write a Sway profile using [this](http://blog.patapon.info/nixos-systemd-sway/) as reference material? 
    - [ ] Move to using LightDM instead of GDM or start using CLI for session management.
  - [ ] Migrate graphical group host configurations to using the Sway profile instead of the GNOME / XFCE profiles.
  - [ ] Remove GNOME / XFCE profiles.
- [ ] Firefox configuration refactors
  - [ ] See if a 1password NUR package exists. If not, create one.
  - [ ] See if a tree style tabs NUR package exists. If not, create one.
  - [ ] Check [here](https://rycee.gitlab.io/home-manager/options.html) for reference to Firefox configuration options under home-manager. Write a config involving the required addons:
    - 1password
    - uBlock Origin
    - Privacy Badger
    - HTTPS Everywhere
    - Tampermonkey
  - [ ] Import into graphical group host configurations.