{
  description = "Lunkentuss user environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachDefaultSystem (system:
    with import nixpkgs { inherit system; };
    let packages = import nix/default.nix { inherit pkgs; };
    in {
      defaultPackage = buildPackages.buildEnv {
        name = "lunkentuss-user-environment";
        paths = packages;
      };
    }
  );
}
