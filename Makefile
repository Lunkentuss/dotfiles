NIX := nix --extra-experimental-features flakes --extra-experimental-features nix-command
export PATH := $(PWD)/result/bin:$(PATH)

define SUCCESS_MSG
Successfully initialized environment

Nix binaries are available in
./result/bin
endef

export SUCCESS_MSG

.PHONY: all
all: nix-build
	./install
	./setup/install_external
	./setup/setup
	@cowsay -f turkey "$${SUCCESS_MSG}" | lolcat

.PHONY: nix-build
nix-build:
	${NIX} build .

.PHONY: nix-update
nix-update:
	${NIX} flake update
