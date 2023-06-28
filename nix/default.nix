{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let pythonPackages = import ./python-packages.nix;
in with builtins; [
  # OpenGL issues with alacritty
  # alacritty
  android-tools
  ansible
  bash-completion
  bashInteractive
  bat
  bluez
  bspwm
  cargo
  coreutils
  cosign
  cowsay
  curl
  dhall
  diff-pdf
  feh
  fd
  figlet
  firefox
  flameshot
  fortune
  fzf
  ghc
  git
  gnumake
  gnused
  go
  hadolint
  hey
  hlint
  html-tidy
  htop
  iproute2
  iputils
  istioctl
  jdk19
  jq
  jsonnet
  k9s
  kazam
  krew
  kotlin
  kubectl
  kubepug
  kubernetes-helm
  k6
  lolcat
  lsof
  manix
  minikube
  # Issues with nix neovim and treesitter, so disable for now
  # neovim
  netcat
  nmap
  nickel
  nix
  nixfmt
  mkcert
  nodePackages.mermaid-cli
  openssh
  openssl
  pyright
  (python310.withPackages pythonPackages)
  pandoc
  pulsemixer
  reveal-md
  ripgrep
  rustc
  scrcpy
  shellcheck
  shfmt
  siege
  slack
  syncthing
  socat
  spotify
  statix
  sxhkd
  tcpdump
  terraform
  gnome.nautilus
  transmission-gtk
  tree
  unrar
  vlc
  viddy
  wrk
  yj
  yq-go
  zathura
  xclip
  # This package makes running "kubectl krew" work, instead of having to run
  # krew directly.
  (runCommand "kubectl-krew" { } ''
    mkdir -p "$out/bin" && ln -sf "${krew}/bin/krew" "$out/bin/kubectl-krew"'')
  (import ./fortune-cow.nix { inherit pkgs; })
  (import ./jksutil.nix { inherit pkgs; })
]
