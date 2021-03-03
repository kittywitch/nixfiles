{ sources, ... }:

{
    home-manager.users.kat = {
        imports = [
            (sources.tf-nix + "/modules/home/secrets.nix")    
        ];
    };
}