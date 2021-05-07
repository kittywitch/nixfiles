# kat's nixfiles

* `nix run -f . deploy.target.<target name>.run.apply`
* `nix run -f . deploy.target.<target name>.run -c terraform destroy`
* `nix build -f . hosts.<host name>.config.system.build.toplevel`
