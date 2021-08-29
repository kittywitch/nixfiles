# nixfiles

[![nodes][]][1]

[This repository on our self hosted git.][7]

These are the NixOS configurations for my systems. I run nothing other than NixOS on my hardware, aside from virtual machines.

## Contents

-   [To-do][]
-   [Nodes][2]
-   [Profiles][]
-   [User Profiles][]
-   [Services][]
-   [Modules][]
-   [CI][]
-   [Dependencies][]
-   [Commands][]

## To-do

-   Consider reworking [kittywitch/nixexprs][] and [kittywitch/nixfiles-base][].
-   Expand [kittywitch/anicca][] to be a module that helps with impermanence, too.
-   Move to using [arcnmx/screenstub][] without any patches.
-   Add swaylock-effects to our theme module.
-   Set up [rinnosuke][] as a nameserver. Either using Knot DNS or BIND. (Need RFC2136.)
-   Migrate [athame][] to OCI.
-   Look into alternatives to Yggdrasil and move to them.
-   Set up IPv6 network handling for our hosts.

## Nodes

| Node          | Purpose                                                |
|---------------|--------------------------------------------------------|
| [athame][]    | Currently the main server. Ad-hoc hetzner cloud box.   |
| [rinnosuke][] | Intended to be a nameserver. Provisioned OCI EPYC box. |
| [beltane][]   | Home server. NAS + HTPC, does DVB stuff.               |
| [samhain][]   | Beloved workstation. Does VFIO.                        |
| [yule][]      | Main laptop.                                           |
| [ostara][]    | CCTV netbook.                                          |

## Profiles

| Profile      | Purpose                                                                                                                                                                          |
|--------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| [base][]     | Base profile, always used. Root access, base16, home-manager, locale, network module, nix, packages, profiles, secrets, shell and sysctl configuration.                          |
| [gui][]      | GUI profile. Provides window managers, [DNSCrypt/dnscrypt-proxy][], filesystem packages, font, NixOS-side GPG, mingetty, NFS, QT, sound (pipewire) and XDG portal configuration. |
| [vfio][]     | Provides host-unspecific VFIO. Fancy patched QEMU from [arcnmx/nixexprs][], [arcnmx/screenstub][] (however, patched in-repo for Q35), AMDGPU vendor-reset and ACS override.      |
| [hardware][] | Sub-profiles for my hardware are provided here. Some are reusable.                                                                                                               |

## User Profiles

| Profile       | Purpose                                                                                                                                               |
|---------------|-------------------------------------------------------------------------------------------------------------------------------------------------------|
| [base][3]     | base16, git, inputrc, packages, rink, secrets, SSH, tmux, weechat, vim, xdg and zsh configuration.                                                    |
| [dev][]       | cookiecutters, doom-emacs (although unused, forced to use PgtkGcc all fancily :3c), packages, rustfmt and (heavier on the node) vim configuration.    |
| [gui][4]      | firefox+userChrome+tst, font, [dnkl/foot][] terminal, GTK, packages, QT, ranger and xdg configuration.                                                |
| [media][]     | mpv, obs, packages and syncplay configuration.                                                                                                        |
| [personal][]  | [arcnmx/rbw][] (fancier rbw), email via [arcnmx/notmuch-vim][], home-manager-side GPG, pass, weechat and zsh configuration.                           |
| [services][5] | User services. weechat and mpd are provided.                                                                                                          |
| [sway][]      | sway, i3gopher, swayidle, swaylock-effects, screenshot tool, [kittywitch/konawall-rs][], mako, wofi, waybar and xkb (custom layout o:) configuration. |

## Services

| Service          | Description                                                              |
|------------------|--------------------------------------------------------------------------|
| [filehost][]     | I sling things in here via SSH/SCP.                                      |
| [fusionpbx][]    | FusionPBX. Fancy PBX.                                                    |
| [gitea][]        | Self-hosted git with mail support.                                       |
| [jellyfin][]     | HTPC/NAS stuff.                                                          |
| [katsplash][]    | A splash screen for some hosts.                                          |
| [kattv-ingest][] | Takes data from kattv, slings to RTMP.                                   |
| [kattv][]        | Takes data from a webcam, slings to kattv-ingest.                        |
| [logrotate][]    | Rotates logs!                                                            |
| [mail][]         | [nixos-mailserver][].                                                    |
| [matrix][]       | Synapse and some appservices. Need to migrate the appservice configs in. |
| [murmur][]       | Mumble!                                                                  |
| [nfs][]          | Network filesy stuff.                                                    |
| [nginx][]        | Our NGINX preset configs.                                                |
| [postgres][]     | Database of choice.                                                      |
| [radicale][]     | CalDAV, integrated with the mail service.                                |
| [restic][]       | Backups!                                                                 |
| [syncplay][]     | Watching videos with friends and lovers. Usually, lovers.                |
| [taskserver][]   | Taskwarrior server.                                                      |
| [transmission][] | Linux distros, I swear.                                                  |
| [tvheadend][]    | DVB-T ingest for Jellyfin and so on!                                     |
| [vaultwarden][]  | Passwords!                                                               |
| [website][]      | Our personal website.                                                    |
| [xmpp][]         | Prosody.                                                                 |
| [zfs][]          | ZFS snapshot settings.                                                   |
| [znc][]          | IRC bouncer!                                                             |

## Modules

This list will include the modules provided by [kittywitch/nixexprs][] as “katexprs”.

| Module                         | Domain                      | Description                                                                                               |
|--------------------------------|-----------------------------|-----------------------------------------------------------------------------------------------------------|
| [arcnmx/nixexprs][]            | NixOS + home-manager        | We use… a lot of these. Syncplay, modprobe, base16, i3gopher, weechat, konawall, shell and probably more. |
| [arcnmx/tf-nix][]              | Meta + NixOS + home-manager | Deployment, secrets and terraform.                                                                        |
| [nix-community/impermanence][] | NixOS + home-manager        | Erase your darlings.                                                                                      |
| katexprs/nftables              | NixOS                       | Uses nftables for the NixOS firewall module.                                                              |
| katexprs/firewall              | NixOS + home-manager        | Per-“domain” (private, public) -> interface abstractions for the firewall. Easier to remember.            |
| katexprs/network (WIP)         | NixOS + home-manager        | Network abstractions. Handles DNS + certs, among virtualHosts.                                            |
| katexprs/fusionpbx (WIP)       | NixOS                       | FusionPBX.                                                                                                |
| nixfiles/secrets               | Meta + NixOS + home-manager | Helper for tf-nix’s secrets.                                                                              |
| nixfiles/deploy                | Meta + NixOS + home-manager | tf-nix deployment integration                                                                             |
| nixfiles/network               | Meta                        | Enables node to host config assignment & NixOS module.                                                    |
| nixfiles/dyndns                | NixOS                       | Dynamic DNS using [glauca.digital][].                                                                     |
| nixfiles/monitoring            | NixOS                       | Grafana, Prometheus, Loki, node-exporter, netdata, promtail, …                                            |
| nixfiles/theme                 | home-manager                | Abstractions for themes. SASS templating.                                                                 |
| hexchen/yggdrasil              | NixOS                       | Yggdrasil ease of use module.                                                                             |

## CI

CI for this repository uses [arcnmx/ci][] and aims to achieve two goals:

| Action       | Purpose                                                                                                            |
|--------------|--------------------------------------------------------------------------------------------------------------------|
| [nodes][6]   | Build and cache host closures, show state of host evaluability/buildability.                                       |
| [niv-cron][] | Automatically update the dependencies used by the repository, cache them and host closure build results with them. |

## Dependencies

| Dependency                      | Reasoning                                                                                              |
|---------------------------------|--------------------------------------------------------------------------------------------------------|
| [nmattia/niv][]                 | Dependency management. Will move to flakes when stable.                                                |
| [nix-community/home-manager][]  | home-manager. Self-explanatory.                                                                        |
| [nix-community/NUR][]           | Firefox extensions and such.                                                                           |
| [arcnmx/tf-nix][]               | The deploy system used, also provides DNS, secrets and node provisioning. (Anything terraform can do.) |
| [arcnmx/ci][]                   | The CI integration system used.                                                                        |
| [arcnmx/nixexprs][]             | Packages and modules I heavily make use of.                                                            |
| [nix-community/impermanence][]  | Impermanence! Erase your darlings.                                                                     |
| [kittywitch/anicca][]           | A helper for moving to impermanence.                                                                   |
| [kittywitch/nixexprs][]         | Packages and modules I have made.                                                                      |
| [nixos-mailserver][]            | The mail server module I use.                                                                          |
| [hexchen/nixfiles][]            | Yggdrasil module. Yggdrasil nodes.                                                                     |
| [nix-community/emacs-overlay][] | An overlay for emacs versions. Currently unused.                                                       |
| [vlaci/nix-doom-emacs][]        | Nixified DOOM emacs. Currently unused.                                                                 |

## Commands

The commands here aside from the `nix build` command are provided through the shell. The `<target>` and `<host>` commands are runners provided through [arcnmx/tf-nix][].

Please use `nix-shell` or [direnv/direnv][]. The shell is not compatible with [nix-community/nix-direnv][].

| Command                                             | Purpose                                                 |
|-----------------------------------------------------|---------------------------------------------------------|
| `nf-update`                                         | Fancier `niv update`.                                   |
| `nf-actions`                                        | Updates CI integrations.                                |
| `nf-test`                                           | Tests CI actions.                                       |
| `<target>-apply`                                    | Deploys to the provided target.                         |
| `<target>-tf`                                       | Provides you a terraform shell for the provided target. |
| `<host>-ssh`                                        | SSH into the provided host.                             |
| `nix build -f . network.nodes.<host>.deploy.system` | Build a system closure for the provided host.           |

  [nodes]: https://github.com/kittywitch/nixfiles/actions/workflows/nodes.yml/badge.svg
  [1]: https://github.com/kittywitch/nixfiles/actions/workflows/nodes.yml
  [To-do]: #to-do
  [2]: #nodes
  [Profiles]: #profiles
  [User Profiles]: #user-profiles
  [Services]: #services
  [Modules]: #modules
  [CI]: #ci
  [Dependencies]: #dependencies
  [Commands]: #commands
  [kittywitch/nixexprs]: https://github.com/kittywitch/nixexprs
  [kittywitch/nixfiles-base]: https://github.com/kittywitch/nixfiles-base
  [kittywitch/anicca]: https://github.com/kittywitch/anicca
  [arcnmx/screenstub]: https://github.com/arcnmx/screenstub
  [rinnosuke]: config/hosts/rinnosuke
  [athame]: config/hosts/athame
  [beltane]: config/hosts/beltane
  [samhain]: config/hosts/samhain
  [yule]: config/hosts/yule
  [ostara]: config/hosts/ostara
  [base]: config/profiles/base
  [gui]: config/profiles/gui
  [DNSCrypt/dnscrypt-proxy]: https://github.com/DNSCrypt/dnscrypt-proxy
  [vfio]: config/profiles/vfio
  [arcnmx/nixexprs]: https://github.com/arcnmx/nixexprs
  [hardware]: config/profiles/hardware
  [3]: config/users/kat/base
  [dev]: config/users/kat/dev
  [4]: config/users/kat/gui
  [dnkl/foot]: https://codeberg.org/dnkl/foot
  [media]: config/users/kat/media
  [personal]: config/users/kat/personal
  [arcnmx/rbw]: https://github.com/arcnmx/rbw
  [arcnmx/notmuch-vim]: https://github.com/arcnmx/notmuch-vim
  [5]: config/users/kat/services
  [sway]: config/users/kat/sway
  [kittywitch/konawall-rs]: https://github.com/kittywitch/konawall-rs
  [filehost]: config/services/filehost/default.nix
  [fusionpbx]: config/services/fusionpbx/default.nix
  [gitea]: config/services/gitea/default.nix
  [jellyfin]: config/services/jellyfin/default.nix
  [katsplash]: config/services/katsplash/default.nix
  [kattv-ingest]: config/services/kattv-ingest/default.nix
  [kattv]: config/services/kattv/default.nix
  [logrotate]: config/services/logrotate/default.nix
  [mail]: config/services/mail/default.nix
  [nixos-mailserver]: https://gitlab.com/simple-nixos-mailserver/nixos-mailserver
  [matrix]: config/services/matrix/default.nix
  [murmur]: config/services/murmur/default.nix
  [nfs]: config/services/nfs/default.nix
  [nginx]: config/services/nginx/default.nix
  [postgres]: config/services/postgres/default.nix
  [radicale]: config/services/radicale/default.nix
  [restic]: config/services/restic/default.nix
  [syncplay]: config/services/syncplay/default.nix
  [taskserver]: config/services/taskserver/default.nix
  [transmission]: config/services/transmission/default.nix
  [tvheadend]: config/services/tvheadend/default.nix
  [vaultwarden]: config/services/vaultwarden/default.nix
  [website]: config/services/website/default.nix
  [xmpp]: config/services/xmpp/default.nix
  [zfs]: config/services/zfs/default.nix
  [znc]: config/services/znc/default.nix
  [arcnmx/tf-nix]: https://github.com/arcnmx/tf-nix
  [nix-community/impermanence]: https://github.com/nix-community/impermanence
  [glauca.digital]: https://glauca.digital
  [arcnmx/ci]: https://github.com/arcnmx/ci
  [6]: ci/nodes.nix
  [niv-cron]: ci/niv-cron.nix
  [nmattia/niv]: https://github.com/nmattia/niv
  [nix-community/home-manager]: https://github.com/nix-community/home-manager
  [nix-community/NUR]: https://github.com/nix-community/NUR
  [hexchen/nixfiles]: https://gitlab.com/hexchen/nixfiles
  [nix-community/emacs-overlay]: https://github.com/nix-community/emacs-overlay
  [vlaci/nix-doom-emacs]: https://github.com/vlaci/nix-doom-emacs
  [direnv/direnv]: https://github.com/direnv/direnv
  [nix-community/nix-direnv]: https://github.com/nix-community/nix-direnv
  [7]: https://git.kittywit.ch/kat/nixfiles
