{
  description = "Lunkentuss user environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.nixpkgs_22_05.url = "github:NixOS/nixpkgs/22.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, nixpkgs_22_05, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
    with import nixpkgs { inherit system; };
    let
    pkgs_22_05 = import nixpkgs_22_05 { inherit system; };
    packages = import nix/default.nix { inherit pkgs; old_pkgs = {"22_05" = pkgs_22_05; }; };
    in {
      defaultPackage = buildPackages.buildEnv {
        name = "lunkentuss-user-environment";
        paths = packages;
      };
    }
  );
}
