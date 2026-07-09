{
  description = "NixOS Vyalozd";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    nixos-grub-themes.url = "github:jeslie0/nixos-grub-themes";
    helium = {
    url = "github:schembriaiden/helium-browser-nix-flake";
    inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
    };

#    quickshell = {
#      url = "github:quickshell-mirror/quickshell";
#      inputs.nixpkgs.follows = "nixpkgs";
#    };
  };

  outputs = { self, nixpkgs, home-manager, spicetify-nix, niri, nixos-hardware, ... }@inputs: {
    nixosConfigurations.awesomebox = nixpkgs.lib.nixosSystem {
      
      specialArgs = { inherit inputs; }; 
      modules = [
        { nixpkgs.hostPlatform = "x86_64-linux"; }
        ./hardware-configuration.nix
        ./configuration.nix
        ./noctalia.nix  
        niri.nixosModules.niri
        nixos-hardware.nixosModules.lenovo-thinkpad-l14-amd
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup"; 
          home-manager.extraSpecialArgs = { inherit inputs; }; 
          home-manager.users.mazachekkuni = import ./home.nix;
          home-manager.sharedModules = [
            spicetify-nix.homeManagerModules.default
        ];
        }
      ];
    };
  };
}
