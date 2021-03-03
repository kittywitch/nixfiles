{ sources, ... }:

{ 
    home-manager.users = {
        imports = [ 
            (sources.tf-nix + "/modules/home/secrets.nix") 
        ]; 
    };
}
