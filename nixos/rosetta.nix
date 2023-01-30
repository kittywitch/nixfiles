_: {
  boot = {
    initrd.availableKernelModules = [ "virtiofs"];
    binfmt.registrations."rosetta" = {
      interpreter = "/run/rosetta/rosetta";
      fixBinary = true;
      wrapInterpreterInShell = false;
      matchCredentials = true;
      magicOrExtension = ''\x7fELF\x02\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x3e\x00'';
      mask = ''\xff\xff\xff\xff\xff\xfe\xfe\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff'';
    };
  };

  nix.settings = {
    extra-platforms = [ "x86_64-linux" ];
    extra-sandbox-paths = [ "/run/rosetta" "/run/binfmt" ];
  };
}
