{ ... }:

let sources = import ../../nix/sources.nix;
in { 
    home-manager.users = {
        imports = [ 
            (sources.tf-nix + "/modules/home/secrets.nix") 
        ]; 
    };
}
