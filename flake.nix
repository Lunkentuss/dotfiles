{
  description = "Lunkentuss user environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/24.11";
  inputs.nixpkgs_22_05.url = "github:NixOS/nixpkgs/22.05";
  inputs.home-manager.url = "github:nix-community/home-manager/release-24.11";
  inputs.stylix.url = "github:danth/stylix/release-24.11";
  inputs.nixvim.url = "github:nix-community/nixvim/nixos-24.11";
  inputs.nixos-hardware.url = "github:NixOs/nixos-hardware";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = inputs@{ self, nixpkgs, nixpkgs_22_05, home-manager, stylix, nixvim
    , nixos-hardware, flake-utils }:
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
            modules = [ ./nixos-rp4/configuration.nix ];
          };
          "nixos-dell-xps" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./nixos-dell-xps/configuration.nix
              nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
            ];
            specialArgs = {
              inherit inputs stylix nixvim;
              packages = allPackages "x86_64-linux";
            };
          };
        };
      };
}
