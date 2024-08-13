{
  description = "Nixcraft: an Archcraft-inspired NixOS distribution";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # other inputs
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: 
  let 
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    variables = import ./variables.nix { inherit pkgs; };
  in
  {
    nixosConfigurations.${variables.hostname} = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit variables; };
      modules = [
        ({ config, pkgs, ... }: { _module.args.variables = variables; })
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${variables.username} = import ./home.nix;
        }
      ];
    };
  };
}
