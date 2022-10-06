.PHONY: all
all: nix-env-install
	./install
	./setup/install_external
	./setup/setup

.PHONY: all
nix-env-install:
	nix-env -if nix/default.nix
