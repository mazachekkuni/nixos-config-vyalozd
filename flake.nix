{
  description = "Конфігурація NixOS з Home Manager, Noctalia та Niri";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, spicetify-nix, niri, ... }@inputs: {
    nixosConfigurations.awesomebox = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; }; 
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        ./noctalia.nix  
        niri.nixosModules.niri
        
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

