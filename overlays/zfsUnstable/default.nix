final: prev: {
  linuxPackagesFor = kernel: (final.linuxPackagesFor kernel).extend (_: kfinal: {
    zfsUnstable = kfinal.zfsUnstable.overrideAttrs (old: { meta = old.meta // { broken = false; }; });
  });
}
