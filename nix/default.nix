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
  hlint
  html-tidy
  htop
  iputils
  jq
  jsonnet
  k9s
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
  nickel
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
  tcpdump
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
