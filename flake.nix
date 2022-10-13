{
  description = "Lunkentuss user environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";

  outputs = { self, nixpkgs }:
    with import nixpkgs { system = "x86_64-linux"; };
    let packages = import nix/default.nix { inherit pkgs; };
    in {
      defaultPackage.x86_64-linux = buildPackages.buildEnv {
        name = "lunkentuss-user-environment";
        paths = packages;
      };
    };
}
