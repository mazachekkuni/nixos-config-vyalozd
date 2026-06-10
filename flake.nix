{
  description = "Конфігурація NixOS з Home Manager, Noctalia та Niri";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

    # ВИПРАВЛЕНО: Використовуємо стабільне GitHub-дзеркало замість git.outfoxxed.me
    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, noctalia, niri, ... }@inputs: {
    # СИНХРОНІЗОВАНО: Назва конфігурації тепер чітко "awesomebox"
    nixosConfigurations.awesomebox = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; }; 
      modules = [
        ./hardware-configuration.nix
        ./configuration.nix
        ./noctalia.nix  
        home-manager.nixosModules.home-manager
        niri.nixosModules.niri
      ];
    };
  };
}
