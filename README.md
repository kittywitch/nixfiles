# nixfiles

The public section of my NixOS configuration, using [arcnmx/tf-nix](https://github.com/arcnmx/tf-nix) for deployment, [arcnmx/ci](https://github.com/arcnmx/ci) for CI and [nmattia/niv](https://github.com/nmattia/niv) for dependency management.

Building and evaluation should hopefully be possible without the trusted submodule. CI should eventually be used to attempt to ensure this.

## Commands

### Deployment

* `nix run -f . deploy.target.<targetName>.run.apply`

* `nix run -f . deploy.target.<targetName>.run -c terraform destroy`

### Host Building

* `nix build -f . hosts.<hostName>.config.system.build.toplevel`
