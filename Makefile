NIX := nix --extra-experimental-features flakes --extra-experimental-features nix-command
NIXPKGS_ALLOW_UNFREE := 1
DMENU_CACHE := $(shell echo "$$HOME/.config/dmenu_run")
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
	nix profile remove 0
	${NIX} profile install --impure .
	{ [[ -f "${DMENU_CACHE}" ]] && rm "${DMENU_CACHE}"; true; }

.PHONY: nix-update
nix-update:
	${NIX} flake update

.PHONY: fmt
fmt:
	./ci/format
