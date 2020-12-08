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

## To-do

### Overall
- [ ] Migrate the secrets file currently in use to be usable for each host.
- [ ] DNS provider migration. (Cloudflare -> Glauca)
  - [ ] Fancy wildcard certificate shenanigans?

### Host: beltane
- [ ] Reinstall with a ZFS root filesystem.
  - [ ] Backup data from current install.
- [ ] Secrets management for Beltane.
- [ ] Additional services configuration for Beltane
  - [ ] Self-hosted mail using [this](https://gitlab.com/simple-nixos-mailserver/nixos-mailserver).
  - [ ] matrix-synapse
  - [ ] matrix-puppet-discord
  - [ ] mautrix-whatsapp
  - [ ] mautrix-telegram
  - [ ] Nextcloud
  - [ ] syncserver
  - [ ] bitwarden_rs

### Host: samhain
- [x] Filesystem revamp of the remaining drives (SSDs).
  - [x] Contemplate Windows (and the Arma drive) abandonment, moving NixOS to a ZFS mirror of the 860 and 850 EVO 250GB models.
  - [x] Games on remaining 120GB SSD?
- [x] Filesystems revamp for redundancy and media server usage.
  - [x] Format "BigExtfs" as an encrypted, perhaps compressed ZFS pool.
  - [x] Migrate the content from "BigEXT" over to the new ZFS pool.
  - [x] Format "BigEXT" to be the mirror of the drive formerly known as "BigExtfs".
  - [x] Excess space on the 3TiB drive should be formatted as either exFAT or ext4.
  - [x] Work out any remaining quirks of this.

### Group: graphical
- [ ] Move all devices to using Sway. 
  - [ ] Write a Sway profile using [this](http://blog.patapon.info/nixos-systemd-sway/) as reference material? 
    - [ ] Move to using LightDM instead of GDM or start using CLI for session management.
  - [ ] Migrate graphical group host configurations to using the Sway profile instead of the GNOME / XFCE profiles.
  - [ ] Remove GNOME / XFCE profiles.
- [ ] Include redshift in the desktop profile. Configure using secrets file post-migration if required.
- [ ] Firefox configuration refactors
  - [ ] See if a 1password NUR package exists. If not, create one.
  - [ ] See if a tree style tabs NUR package exists. If not, create one.
  - [ ] Check [here](https://rycee.gitlab.io/home-manager/options.html) for reference to Firefox configuration options under home-manager. Write a config involving the required addons:
    - 1password
    - uBlock Origin
    - Privacy Badger
    - HTTPS Everywhere
    - Tampermonkey
  - [ ] Attach self-hosted syncserver to profile.
  - [ ] Import into graphical group host configurations.