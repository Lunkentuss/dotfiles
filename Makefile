.PHONY: all
all: nix-env-install
	./install
	./setup/install_external
	./setup/setup
	@cowsay -f turkey "Successfully initialized environment" | lolcat

.PHONY: nix-env-install
nix-env-install:
	nix \
	--extra-experimental-features flakes \
	--extra-experimental-features nix-command \
	build
