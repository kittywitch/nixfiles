# nixfiles

[![nodes](https://github.com/kittywitch/nixfiles/actions/workflows/nodes.yml/badge.svg)](https://github.com/kittywitch/nixfiles/actions/workflows/nodes.yml)

## Dependencies

| Dependency | Reasoning |
| --- | --- |
| [nmattia/niv](https://github.com/nmattia/niv) | Dependency management. |
| [nix-community/home-manager](https://github.com/nix-community/home-manager) | home-manager. Self-explanatory. |
| [nix-community/NUR](https://github.com/nix-community/NUR) | Firefox extensions and such. |
| [arcnmx/tf-nix](https://github.com/arcnmx/tf-nix) | The deploy system used. |
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

### Deployment

* `<targetName>-apply`
* `<targetName>-tf`

### Host Building

* `nix build -f . network.nodes.<hostName>.deploy.system`
