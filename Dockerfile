from nixos/nix:2.12.0pre20221005_ac0fb38

RUN nix \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes \
  profile install github:lunkentuss/dotfiles
