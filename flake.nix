{
  description = "Lunkentuss user environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/24.11";
    nixpkgs_22_05.url = "github:NixOS/nixpkgs/22.05";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    stylix.url = "github:danth/stylix/release-24.11";
    nixvim.url = "github:nix-community/nixvim/nixos-24.11";
    nixos-hardware.url = "github:NixOs/nixos-hardware";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs_22_05, home-manager, stylix, nixvim
    , nixos-hardware, nixos-generators, flake-utils }:
    let
      allPackages = (system:
        with import nixpkgs { inherit system; };
        let
          pkgs_22_05 = import nixpkgs_22_05 { inherit system; };
          packages = import nix/default.nix {
            inherit pkgs;
            old_pkgs = { "22_05" = pkgs_22_05; };
          };
        in import nix/default.nix {
          inherit pkgs;
          old_pkgs = { "22_05" = pkgs_22_05; };
        });
    in flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs { inherit system; }; {
        defaultPackage = buildPackages.buildEnv {
          name = "lunkentuss-user-environment";
          paths = allPackages system;
        };
      }) // {
        nixosConfigurations = {
          "nixos-rp4" = nixpkgs.lib.nixosSystem {
            system = "aarch64-linux";
            modules = [
              ./nixos/hosts/rp4/configuration.nix
              ./nixos/hardware/rp4/configuration.nix
            ];
            specialArgs = {
              rootDir = ./.;
            };
          };
          "nixos-dell-xps" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./nixos/hosts/desktop/configuration.nix
              ./nixos/hardware/dell-xps-15-9520/configuration.nix
              nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
            ];
            specialArgs = {
              inherit inputs stylix nixvim;
              packages = allPackages "x86_64-linux";
              rootDir = ./.;
            };
          };
          "nixos-desktop-vm" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./nixos/hosts/desktop/configuration.nix
              nixos-generators.nixosModules.all-formats
            ];
            specialArgs = {
              inherit inputs stylix nixvim;
              packages = allPackages "x86_64-linux";
              rootDir = ./.;
            };
          };
          "live-iso" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              ./nixos/hosts/live-iso/configuration.nix
            ];
            specialArgs = { rootDir = ./.; };
          };
        };
      };
}
