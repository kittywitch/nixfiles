# nixfiles

[![nodes](https://github.com/kittywitch/nixfiles/actions/workflows/nodes.yml/badge.svg)](https://github.com/kittywitch/nixfiles/actions/workflows/nodes.yml)

These are the NixOS configurations for my systems. I run nothing other than NixOS on my hardware, aside from virtual machines.

## Contents

* [Nodes](#nodes)
* [Profiles](#profiles)
* [User Profiles](#user-profiles)
* [Services](#services)
* [Modules](#modules)
* [CI](#ci)
* [Dependencies](#dependencies)
* [Commands](#commands)

## Nodes

| Node | Purpose |
| --- | --- |
| [athame](config/hosts/athame) | Currently the main server. Ad-hoc hetzner cloud box. |
| [rinnosuke](config/hosts/rinnosuke) | Intended to be a nameserver. Provisioned OCI EPYC box. |
| [beltane](config/hosts/beltane) | Home server. NAS + HTPC, does DVB stuff. |
| [samhain](config/hosts/samhain) | Beloved workstation. Does VFIO. |
| [yule](config/hosts/yule) | Main laptop. |
| [ostara](config/hosts/ostara) | CCTV netbook. |

## Profiles

| Profile | Purpose |
| --- | --- |
| [base](config/profiles/base) | Base profile, always used. Root access, base16, home-manager, locale, network module, nix, packages, profiles, secrets, shell and sysctl configuration. |
| [gui](config/profiles/gui) | GUI profile. Provides window managers, [DNSCrypt/dnscrypt-proxy](https://github.com/DNSCrypt/dnscrypt-proxy), filesystem packages, font, NixOS-side GPG, mingetty, NFS, QT, sound (pipewire) and XDG portal configuration. |
| [vfio](config/profiles/vfio) | Provides host-unspecific VFIO. Fancy patched QEMU from [arcnmx/nixexprs](https://github.com/arcnmx/nixexprs), [arcnmx/screenstub](https://github.com/arcnmx/screenstub) (however, patched in-repo for Q35), AMDGPU vendor-reset and ACS override. |
| [hardware](config/profiles/hardware) | Sub-profiles for my hardware are provided here. Some are reusable. |

## User Profiles

| Profile | Purpose |
| --- | --- |
| [base](config/users/kat/base) | base16, git, inputrc, packages, rink, secrets, SSH, tmux, weechat, vim, xdg and zsh configuration. |
| [dev](config/users/kat/dev) | cookiecutters, doom-emacs (although unused, forced to use PgtkGcc all fancily :3c), packages, rustfmt and (heavier on the node) vim configuration. |
| [gui](config/users/kat/gui) | firefox+userChrome+tst, font, [dnkl/foot](https://codeberg.org/dnkl/foot) terminal, GTK, packages, QT, ranger and xdg configuration. |
| [media](config/users/kat/media) | mpv, obs, packages and syncplay configuration. |
| [personal](config/users/kat/personal) | [arcnmx/rbw](https://github.com/arcnmx/rbw) (fancier rbw), email via [arcnmx/notmuch-vim](https://github.com/arcnmx/notmuch-vim), home-manager-side GPG, pass, weechat and zsh configuration. |
| [services](config/users/kat/services) | User services. weechat and mpd are provided. |
| [sway](config/users/kat/sway) | sway, i3gopher, swayidle, swaylock-effects, screenshot tool, [kittywitch/konawall-rs](https://github.com/kittywitch/konawall-rs), mako, wofi, waybar and xkb (custom layout o:) configuration. |

## Services

| Service | Description |
| --- | --- |
| [filehost](config/services/filehost/default.nix) | I sling things in here via SSH/SCP. |
| [fusionpbx](config/services/fusionpbx/default.nix) | FusionPBX. Fancy PBX. |
| [gitea](config/services/gitea/default.nix) | Self-hosted git with mail support. |
| [jellyfin](config/services/jellyfin/default.nix) | HTPC/NAS stuff. |
| [katsplash](config/services/katsplash/default.nix) | A splash screen for some hosts. |
| [kattv-ingest](config/services/kattv-ingest/default.nix) | Takes data from kattv, slings to RTMP. |
| [kattv](config/services/kattv/default.nix) | Takes data from a webcam, slings to kattv-ingest. |
| [logrotate](config/services/logrotate/default.nix) | Rotates logs! |
| [mail](config/services/mail/default.nix) | [nixos-mailserver](https://gitlab.com/simple-nixos-mailserver/nixos-mailserver). |
| [matrix](config/services/matrix/default.nix) | Synapse and some appservices. Need to migrate the appservice configs in. |
| [murmur](config/services/murmur/default.nix) | Mumble! |
| [nfs](config/services/nfs/default.nix) | Network filesy stuff. |
| [nginx](config/services/nginx/default.nix) | Our NGINX preset configs. |
| [postgres](config/services/postgres/default.nix) | Database of choice. |
| [radicale](config/services/radicale/default.nix) | CalDAV, integrated with the mail service. |
| [restic](config/services/restic/default.nix) | Backups! |
| [syncplay](config/services/syncplay/default.nix) | Watching videos with friends and lovers. Usually, lovers. |
| [taskserver](config/services/taskserver/default.nix) | Taskwarrior server. |
| [transmission](config/services/transmission/default.nix) | Linux distros, I swear. |
| [tvheadend](config/services/tvheadend/default.nix) | DVB-T ingest for Jellyfin and so on! |
| [vaultwarden](config/services/vaultwarden/default.nix) | Passwords! |
| [website](config/services/website/default.nix) | Our personal website. |
| [xmpp](config/services/xmpp/default.nix) | Prosody. |
| [zfs](config/services/zfs/default.nix) | ZFS snapshot settings. |
| [znc](config/services/znc/default.nix) | IRC bouncer! |

## Modules

This list will include the modules provided by [kittywitch/nixexprs](https://github.com/kittywitch/nixexprs) as "katexprs".

| Module | Domain | Description |
| --- | --- | --- |
| [arcnmx/nixexprs](https://github.com/arcnmx/nixexprs) | NixOS + home-manager | We use... a lot of these. Syncplay, modprobe, base16, i3gopher, weechat, konawall, shell and probably more. |
| [arcnmx/tf-nix](https://github.com/arcnmx/tf-nix) | Meta + NixOS + home-manager | Deployment, secrets and terraform. |
| [nix-community/impermanence](https://github.com/nix-community/impermanence) | NixOS + home-manager | Erase your darlings. |
| katexprs/nftables | NixOS | Uses nftables for the NixOS firewall module. |
| katexprs/firewall | NixOS + home-manager | Per-"domain" (private, public) -> interface abstractions for the firewall. Easier to remember. |
| katexprs/network (WIP) | NixOS + home-manager | Network abstractions. Handles DNS + certs, among virtualHosts. |
| katexprs/fusionpbx (WIP) | NixOS | FusionPBX. |
| nixfiles/secrets | Meta + NixOS + home-manager | Helper for tf-nix's secrets. |
| nixfiles/deploy | Meta + NixOS + home-manager | tf-nix deployment integration |
| nixfiles/network | Meta | Enables node to host config assignment & NixOS module. |
| nixfiles/dyndns | NixOS | Dynamic DNS using [glauca.digital](https://glauca.digital). |
| nixfiles/monitoring | NixOS | Grafana, Prometheus, Loki, node-exporter, netdata, promtail, ... |
| nixfiles/theme | home-manager | Abstractions for themes. SASS templating. |
| hexchen/yggdrasil | NixOS | Yggdrasil ease of use module. |

## CI

CI for this repository uses [arcnmx/ci](https://github.com/arcnmx/ci) and aims to achieve two goals:

| Action | Purpose |
| --- | --- |
| [nodes](ci/nodes.nix) | Build and cache host closures, show state of host evaluability/buildability. |
| [niv-cron](ci/niv-cron.nix) | Automatically update the dependencies used by the repository, cache them and host closure build results with them.  |

## Dependencies

| Dependency | Reasoning |
| --- | --- |
| [nmattia/niv](https://github.com/nmattia/niv) | Dependency management. Will move to flakes when stable. |
| [nix-community/home-manager](https://github.com/nix-community/home-manager) | home-manager. Self-explanatory. |
| [nix-community/NUR](https://github.com/nix-community/NUR) | Firefox extensions and such. |
| [arcnmx/tf-nix](https://github.com/arcnmx/tf-nix) | The deploy system used, also provides DNS, secrets and node provisioning. (Anything terraform can do.) |
| [arcnmx/ci](https://github.com/arcnmx/ci) | The CI integration system used. |
| [arcnmx/nixexprs](https://github.com/arcnmx/nixexprs) | Packages and modules I heavily make use of. |
| [nix-community/impermanence](https://github.com/nix-community/impermanence) | Impermanence! Erase your darlings. |
| [kittywitch/anicca](https://github.com/kittywitch/anicca) | A helper for moving to impermanence. |
| [kittywitch/nixexprs](https://github.com/kittywitch/nixexprs) | Packages and modules I have made. |
| [nixos-mailserver](https://gitlab.com/simple-nixos-mailserver/nixos-mailserver) | The mail server module I use. |
| [hexchen/nixfiles](https://gitlab.com/hexchen/nixfiles) | Yggdrasil module. Yggdrasil nodes. |
| [nix-community/emacs-overlay](https://github.com/nix-community/emacs-overlay) | An overlay for emacs versions. Currently unused. |
| [vlaci/nix-doom-emacs](https://github.com/vlaci/nix-doom-emacs) | Nixified DOOM emacs. Currently unused. |

## Commands

The commands here aside from the `nix build` command are provided through the shell. The `<target>` and `<host>` commands are runners provided through [arcnmx/tf-nix](https://github.com/arcnmx/tf-nix).

Please use `nix-shell` or [direnv/direnv](https://github.com/direnv/direnv). The shell is not compatible with [nix-community/nix-direnv](https://github.com/nix-community/nix-direnv).

| Command | Purpose |
| --- | --- |
| `nf-update` | Fancier `niv update`. |
| `nf-actions` | Updates CI integrations. |
| `nf-test` | Tests CI actions. |
| `<target>-apply` | Deploys to the provided target. |
| `<target>-tf` | Provides you a terraform shell for the provided target. |
| `<host>-ssh` | SSH into the provided host. |
| `nix build -f . network.nodes.<host>.deploy.system` | Build a system closure for the provided host. |
