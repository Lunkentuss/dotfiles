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
        metaPackage = runCommand
          "user-environment"
          {}
          (
            pipe
              packages
              [
                (map (package: filesystem.listFilesRecursive "${package}/bin"))
                flatten
                (map (package: ''ln -fs "${package}" "$out/bin/$(basename ${package})"'' + "\n"))
                concatStrings
                (cmds: ''mkdir -p "$out/bin"'' + "\n" + cmds)
              ]
          );
      in
        {
          defaultPackage.x86_64-linux = metaPackage;
        };
}
