{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    (callPackage ida-pro {
      runfile = pkgs.requireFile {
        name = "ida-pro_92_x64linux.run";
        message = "Don't copy that floppy~!";
        hash = "sha256-qt0PiulyuE+U8ql0g0q/FhnzvZM7O02CdfnFAAjQWuE=";
      };
      normalScript = pkgs.requireFile {
        name = "ida-normalScript.py";
        message = "Floppy; copied.";
        hash = "sha256-8UWf1RKsRNWJ8CC6ceDeIOv4eY3ybxZ9tv5MCHx80NY=";
      };
    })
    android-studio
  ];
}
