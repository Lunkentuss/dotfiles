from nixos/nix:2.12.0pre20221005_ac0fb38

RUN NIXPKGS_ALLOW_UNFREE=1 nix \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes \
  profile install \
  --priority 0 \
  --impure \
  github:lunkentuss/dotfiles
