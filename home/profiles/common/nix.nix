_: {
    nix.gc = {
        automatic = true;
        frequency = "weekly";
        persistent = true;
    };
}