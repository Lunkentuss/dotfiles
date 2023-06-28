NIX := nix --extra-experimental-features flakes --extra-experimental-features nix-command
NIXPKGS_ALLOW_UNFREE := 1
export NIXPKGS_ALLOW_UNFREE

define SUCCESS_MSG
Successfully initialized environment

Nix binaries are available in
./result/bin
endef

export SUCCESS_MSG

.PHONY: all
all: nix-profile-install
	./install
	./setup/install_external
	@cowsay -f turkey "$${SUCCESS_MSG}" | lolcat

.PHONY: nix-build
nix-build:
	${NIX} build --impure .

.PHONY: nix-profile-install
nix-profile-install: nix-build
	${NIX} profile list \
		| grep "lunkentuss-user-environment" \
		| sed -E 's/([0-9]*).*/\1/' \
		| xargs ${NIX} profile remove
	${NIX} profile install --impure .

.PHONY: nix-update
nix-update:
	${NIX} flake update

.PHONY: fmt
fmt:
	./ci/format
