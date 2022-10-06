{
  pkgs ? import <nixpkgs> {}
}:
with pkgs;
with builtins;
[
  cowsay
  fortune
  fd
  hadolint
  lolcat
  (import ./fortune-cow.nix { inherit pkgs; })
]
