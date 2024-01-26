_: let
in {
  boot.kernelModules = ["kvm-intel"];
  services.thermald.enable = true;
}
