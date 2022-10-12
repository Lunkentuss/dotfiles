{
  pkgs ? import <nixpkgs> {}
}:
with pkgs;
with builtins;
[
  cowsay
  dhall
  fortune
  fd
  hadolint
  html-tidy
  jq
  lolcat
  manix
  nixfmt
  shellcheck
  statix
  yj
  yq-go
  (import ./fortune-cow.nix { inherit pkgs; })
]
