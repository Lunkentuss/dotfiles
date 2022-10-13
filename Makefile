NIX := nix --extra-experimental-features flakes --extra-experimental-features nix-command

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
	./setup/setup
	@cowsay -f turkey "$${SUCCESS_MSG}" | lolcat

.PHONY: nix-build
nix-build:
	${NIX} build .

.PHONY: nix-profile-install
nix-profile-install: nix-build
	nix profile list \
		| grep "lunkentuss-user-environment" \
		| sed -E 's/([0-9]*).*/\1/' \
		| xargs nix profile remove
	${NIX} profile install .

.PHONY: nix-update
nix-update:
	${NIX} flake update
