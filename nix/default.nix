{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let pythonPackages = import ./python-packages.nix;
in with builtins; [
  ansible
  bash-completion
  bashInteractive
  bspwm
  cosign
  cowsay
  curl
  dhall
  fd
  figlet
  firefox
  fortune
  fzf
  git
  ghc
  hadolint
  hey
  html-tidy
  htop
  iputils
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
  (python310.withPackages pythonPackages)
  ripgrep
  shellcheck
  shfmt
  siege
  slack
  socat
  statix
  sxhkd
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
