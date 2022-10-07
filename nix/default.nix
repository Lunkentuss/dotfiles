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
  shellcheck
  html-tidy
  yj
  yq-go
  (import ./fortune-cow.nix { inherit pkgs; })
]
