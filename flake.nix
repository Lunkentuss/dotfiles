{
  description = "Lunkentuss user environment";
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-22.05;

  outputs = { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
      with pkgs;
      with lib;
      with builtins;
      let
        packages = import nix/default.nix { inherit pkgs; };
        metaPackage = pipe
          packages
          [
            (map (x: "${x}\n"))
            concatStrings
            (text: writeTextFile {
              inherit text;
              name = "lunkentuss-user-environment";
            })
          ];
      in
        {
          defaultPackage.x86_64-linux = metaPackage;
        };
}
