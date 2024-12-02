{ pkgs ? import <nixpkgs> { }, old_pkgs }:
with pkgs;
let pythonPackages = import ./python-packages.nix;
in with builtins; [
  acme-sh
  acpi
  # OpenGL issues with alacritty
  # alacritty
  android-studio
  android-tools
  ansible
  bash-completion
  bashInteractive
  bat
  bettercap
  bfg-repo-cleaner
  blender
  bluez
  bspwm
  bws
  cargo
  clippy
  coreutils
  cosign
  cowsay
  ctop
  curl
  dbeaver-bin
  delta
  dhall
  diff-pdf
  dive
  dmenu
  fd
  feh
  ffcast
  ffmpeg
  figlet
  firefox
  # Can't create SUID flag on binary.
  # firejail
  flameshot
  fortune
  fzf
  gdal
  genxword
  geos
  ghc
  git
  git-filter-repo
  gitlab-runner
  glow
  gnome.nautilus
  gnumake
  gnused
  go
  google-chrome
  google-java-format
  old_pkgs."22_05".hadolint
  hey
  hlint
  hpack
  html-tidy
  htop
  # Contains telnet
  inetutils
  ipcalc
  iproute2
  iputils
  istioctl
  jdk21
  jinja2-cli
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
  lurk
  manix
  mdbook
  minikube
  # Issues with nix neovim and treesitter, so disable for now
  # neovim
  netcat
  mkcert
  mariadb
  nickel
  nix
  nixfmt
  nmap
  nodePackages.markdownlint-cli
  nodePackages.mermaid-cli
  nodePackages.prettier
  nodejs_20
  openssh
  openssl
  (python312.withPackages pythonPackages)
  pandoc
  parallel
  pip-audit
  poetry
  postgresql
  proxychains
  pulsemixer
  pyright
  redis
  reveal-md
  ripgrep
  rsync
  ruff
  rustc
  rustfmt
  scrcpy
  screen
  shellcheck
  shfmt
  siege
  skopeo
  slack
  slop
  socat
  spotify
  stack
  statix
  strace
  sxhkd
  syncthing
  tbls
  tcpdump
  terraform
  # Tex is needed to run pandoc ... -o output.pdf
  playwright-test
  protoc-gen-go
  qemu
  texlive.combined.scheme-full
  traceroute
  transmission-gtk
  tree
  unrar
  unzip
  vhs
  viddy
  vlc
  websocat
  wget
  whois
  wireshark
  wrk
  xclip
  yarn
  yj
  yq-go
  zathura
  # This package makes running "kubectl krew" work, instead of having to run
  # krew directly.
  (runCommand "kubectl-krew" { } ''
    mkdir -p "$out/bin" && ln -sf "${krew}/bin/krew" "$out/bin/kubectl-krew"'')
  (import ./fortune-cow.nix { inherit pkgs; })
  (import ./jksutil.nix { inherit pkgs; })
]
