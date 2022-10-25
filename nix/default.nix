{ pkgs ? import <nixpkgs> { } }:
with pkgs;
with builtins; [
  ansible
  cosign
  cowsay
  curl
  dhall
  fd
  figlet
  fortune
  fzf
  git
  ghc
  hadolint
  hey
  html-tidy
  htop
  jq
  jsonnet
  kazam
  krew
  kotlin
  kubectl
  kubernetes-helm
  lolcat
  lsof
  manix
  minikube
  neovim
  netcat
  nmap
  nixfmt
  pandoc
  (python310.withPackages (p: with p; [ black j2cli pyyaml pytest ]))
  ripgrep
  shellcheck
  siege
  slack
  socat
  statix
  terraform
  tree
  vlc
  viddy
  yj
  yq-go
  zathura
  # This package makes running "kubectl krew" work, instead of having to run
  # krew directly.
  (runCommand "kubectl-krew" { } ''
    mkdir -p "$out/bin" && ln -sf "${krew}/bin/krew" "$out/bin/kubectl-krew"'')
  (import ./fortune-cow.nix { inherit pkgs; })
]
