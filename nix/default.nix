{ pkgs ? import <nixpkgs> { }, old_pkgs }:
with pkgs;
let pythonPackages = import ./python-packages.nix;
in with builtins; [
  acpi
  # OpenGL issues with alacritty
  # alacritty
  android-studio
  android-tools
  ansible
  bash-completion
  bashInteractive
  bat
  bluez
  bspwm
  bws
  cargo
  coreutils
  cosign
  cowsay
  curl
  dbeaver
  dhall
  diff-pdf
  dmenu
  fd
  feh
  figlet
  firefox
  # Can't create SUID flag on binary.
  # firejail
  flameshot
  fortune
  fzf
  geos
  gdal
  ghc
  git
  git-filter-repo
  gitlab-runner
  gnumake
  gnused
  go
  google-chrome
  google-java-format
  old_pkgs."22_05".hadolint
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
  k6
  k9s
  kazam
  kotlin
  krew
  kubectl
  ktfmt
  kubepug
  kubernetes-helm
  lm_sensors
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
  nodejs_20
  nodePackages.markdownlint-cli
  mkcert
  nodePackages.mermaid-cli
  openssh
  openssl
  (python310.withPackages pythonPackages)
  pandoc
  parallel
  postgresql
  pulsemixer
  pyright
  reveal-md
  ripgrep
  rsync
  ruff
  rustc
  scrcpy
  shellcheck
  shfmt
  siege
  skopeo
  slack
  socat
  spotify
  stack
  statix
  strace
  sxhkd
  gnome.nautilus
  syncthing
  tcpdump
  terraform
  # Tex is needed to run pandoc ... -o output.pdf
  texlive.combined.scheme-full
  transmission-gtk
  tree
  unrar
  unzip
  vlc
  viddy
  wget
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
