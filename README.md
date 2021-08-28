# nixfiles

[![nodes](https://github.com/kittywitch/nixfiles/actions/workflows/nodes.yml/badge.svg)](https://github.com/kittywitch/nixfiles/actions/workflows/nodes.yml)

These are the NixOS configurations for my systems. I run nothing other than NixOS on my hardware, aside from virtual machines.

## Contents

* [Nodes](#nodes)
* [Profiles](#profiles)
* [User Profiles](#user-profiles)
* [CI](#ci)
* [Dependencies](#dependencies)
* [Commands](#commands)

## Nodes

| Node | Purpose |
| --- | --- |
| [athame](config/hosts/athame) | Currently the main server. Ad-hoc hetzner cloud box. |
| [rinnosuke](config/hosts/rinnosuke) | Intended to be a nameserver. Provisioned OCI EPYC box. |
| [beltane](config/hosts/beltane) | Home server. |
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
| [base](config/users/kat/base) | base16, git, inputrc, packages, pass, rink, secrets, SSH, tmux, weechat, vim, xdg and zsh configuration. |
| [dev](config/users/kat/dev) | cookiecutters, doom-emacs (although unused, forced to use PgtkGcc all fancily :3c), packages, rustfmt and (heavier on the node) vim configuration. |
| [gui](config/users/kat/gui) | firefox+userChrome+tst, font, [dnkl/foot](https://codeberg.org/dnkl/foot) terminal, GTK, packages, QT, ranger and xdg configuration. |
| [media](config/users/kat/media) | mpv, obs, packages and syncplay configuration. |
| [personal](config/users/kat/personal) | email (notmuch), home-manager-side GPG, weechat and zsh configuration. |
| [services](config/users/kat/services) | User services. weechat and mpd are provided. |
| [sway](config/users/kat/sway) | sway, i3gopher, swayidle, swaylock-effects, screenshot tool, konawall, mako, wofi, waybar and xkb (custom layout o:) configuration. |

## CI

CI for this repository uses [arcnmx/ci](https://github.com/arcnmx/ci) and aims to achieve two goals:

| Action | Purpose |
| --- | --- |
| [nodes](ci/nodes.nix) | Build and cache host closures, show state of host evaluability/buildability |
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
