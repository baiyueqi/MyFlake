{

  description = "All of our deployment, period";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # nix flake lock --override-input nixpkgs "github:NixOS/nixpkgs?rev=b681065d0919f7eb5309a93cea2cfa84dec9aa88"
    utils.url = "github:numtide/flake-utils";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager?ref=release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    wsl.url =
      "github:nix-community/NixOS-WSL?rev=34eda458bd3f6bad856a99860184d775bc1dd588";
    wsl.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, wonder-foundations, home-manager
    , ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
        overlays = [ inputs.ml-pkgs.overlays.gen-ai ];
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        config.allowBroken = true;
      };
      pkgs-macos = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
        config.allowBroken = true;
      };
    in {
      templates = {
        python-dev-starter = {
          path = ./templates/python-dev-starter;
          description = "Generate a python dev starter package.";
        };
        rust-dev-starter = {
          path = ./templates/rust-dev-starter;
          description = "Generate a rust dev starter package.";
        };
      };
      nixosConfigurations = {
        wsl = nixpkgs.lib.nixosSystem rec {
          inherit system;
          modules = [
            inputs.home-manager.nixosModules.home-manager
            inputs.wsl.nixosModules.wsl
            ./machines/wsl
            # ({
            #   nixpkgs.overlays =
            #     [ (final: prev: { duckdb = pkgs-unstable.duckdb; }) ];
            # })
          ];
        };
      };
    
      homeConfigurations.nixos = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./home/default.nix
          {
            home = {
              username = "nixos";
              homeDirectory = "/home/nixos";
              stateVersion = "22.11";
            };
          }
        ];
      };
    };
}
