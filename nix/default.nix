{ pkgs, override_pkgs }:
with pkgs;
let pythonPackages = import ./python-packages.nix;
in with builtins; [
  acme-sh
  acpi
  # TODO: remove from arch
  alsa-utils
  # OpenGL issues with alacritty: TODO, remove from arch
  alacritty
  android-studio
  android-tools
  ansible
  awscli2
  aws-sam-cli
  bash-completion
  bashInteractive
  bat
  bettercap
  bfg-repo-cleaner
  blender
  bluez
  bspwm
  bws
  override_pkgs.unstable.cargo
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
  dig
  dive
  dmenu
  dunst
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
  gcc
  ghc
  git
  git-filter-repo
  gitlab-runner
  glow
  nautilus
  gnumake
  gnused
  go
  google-chrome
  google-java-format
  override_pkgs."22_05".hadolint
  hey
  hlint
  hpack
  html-tidy
  htop
  httptap
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
  # kubectl-tree
  ktfmt
  kubepug
  kubernetes-helm
  libimobiledevice
  lm_sensors
  lolcat
  lsof
  lurk
  manix
  mariadb
  mdbook
  minikube
  mkcert
  netcat
  nixos-generators
  nickel
  nix
  nixfmt-classic
  nmap
  nodePackages.markdownlint-cli
  nodePackages.mermaid-cli
  nodePackages.prettier
  nodePackages.aws-cdk
  nodejs_20
  openssh
  openssl
  (python312.withPackages pythonPackages)
  pandoc
  parallel
  pip-audit
  pkg-config
  poetry
  postgresql
  proxychains
  # Contains fuser
  psmisc
  pulsemixer
  pyright
  redis
  reveal-md
  ripgrep
  rsync
  ruff
  override_pkgs.unstable.rustc
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
  p11-kit
  # Tex is needed to run pandoc ... -o output.pdf
  playwright-test
  protoc-gen-go
  qemu
  texlive.combined.scheme-full
  traceroute
  transmission_4-gtk
  tree
  unrar
  unzip
  # Doesn't build
  # uucp
  vhs
  viddy
  vim
  neovim
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
  xorg.xset
  xsecurelock
  zathura
  # This package makes running "kubectl krew" work, instead of having to run
  # krew directly.
  (runCommand "kubectl-krew" { } ''
    mkdir -p "$out/bin" && ln -sf "${krew}/bin/krew" "$out/bin/kubectl-krew"'')
  (import ./fortune-cow.nix { inherit pkgs; })
  (import ./jksutil.nix { inherit pkgs; })
  (import ./kubectl-ctx.nix { inherit pkgs; })
  (import ./kubectl-ns.nix { inherit pkgs; })
]
