{
  description = "Lunkentuss user environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
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
      }) // (let
        simplifyNixosConfigurations = nixpkgs.lib.concatMapAttrs
          (hostname: config: {
            ${hostname} = nixpkgs.lib.nixosSystem (config // {
              specialArgs = {
                inherit inputs stylix nixvim hostname;
                packages = allPackages "x86_64-linux";
                rootDir = ./.;
              };
            });
          });
      in {
        nixosConfigurations = simplifyNixosConfigurations {
          "nixos-rp4" = {
            system = "aarch64-linux";
            modules = [
              ./nixos/hardware/rp4/configuration.nix
              ./nixos/modules/rp4/configuration.nix
            ];
          };
          "nixos-dell-xps" = {
            system = "x86_64-linux";
            modules = [
              ./nixos/hardware/dell-xps-15-9520/configuration.nix
              nixos-hardware.nixosModules.dell-xps-15-9520-nvidia
              ./nixos/modules/desktop/configuration.nix
              ./nixos/modules/virtualbox_host/configuration.nix
            ];
          };
          "vm-virtualbox-tmp" = {
            system = "x86_64-linux";
            modules = [
              ./nixos/hardware/virtualbox/configuration.nix
              ./nixos/modules/desktop/configuration.nix
              ./nixos/modules/virtualbox_guest/configuration.nix
            ];
          };
          "nixos-desktop-vm" = {
            system = "x86_64-linux";
            modules = [
              ./nixos/modules/desktop/configuration.nix
              ./nixos/modules/virtualbox_guest/configuration.nix
              nixos-generators.nixosModules.all-formats
            ];
          };
          "live-iso" = {
            system = "x86_64-linux";
            modules = [
              "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              ./nixos/modules/live-iso/configuration.nix
            ];
          };
        };
      });
}
