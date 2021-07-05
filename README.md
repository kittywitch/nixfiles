# nixfiles

[![hosts](https://github.com/kittywitch/nixfiles/actions/workflows/hosts.yml/badge.svg)](https://github.com/kittywitch/nixfiles/actions/workflows/hosts.yml)

The public section of my NixOS configuration, using [arcnmx/tf-nix](https://github.com/arcnmx/tf-nix) for deployment, [arcnmx/ci](https://github.com/arcnmx/ci) for CI and [nmattia/niv](https://github.com/nmattia/niv) for dependency management.

## Commands

### Deployment

* `<targetName>-deploy`
* `<targetName>-tf`

### Host Building

* `nix build -f . network.nodes.<hostName>.deploy.system`
