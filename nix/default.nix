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
  jq
  lolcat
  nixfmt
  shellcheck
  html-tidy
  yj
  yq-go
  (import ./fortune-cow.nix { inherit pkgs; })
]
