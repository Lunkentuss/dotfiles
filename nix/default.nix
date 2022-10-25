{ pkgs ? import <nixpkgs> { } }:
with pkgs;
with builtins; [
  cowsay
  dhall
  fortune
  fd
  hadolint
  html-tidy
  jq
  krew
  kubectl
  kubernetes-helm
  lolcat
  manix
  nixfmt
  shellcheck
  statix
  yj
  yq-go
  (runCommand "kubectl-krew" { } ''
    mkdir -p "$out/bin" && ln -sf "${krew}/bin/krew" "$out/bin/kubectl-krew"'')
  (import ./fortune-cow.nix { inherit pkgs; })
]