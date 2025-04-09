NIX := nix --extra-experimental-features flakes --extra-experimental-features nix-command
NIXPKGS_ALLOW_UNFREE := 1
DMENU_CACHE := $(shell echo "$$HOME/.config/dmenu_run")
export NIXPKGS_ALLOW_UNFREE=1

define SUCCESS_MSG
Successfully initialized environment

Nix binaries are available in
./result/bin
endef

export SUCCESS_MSG

.PHONY: nixos-rebuild-switch
nixos-rebuild-switch:
	nixos-rebuild --impure switch

.PHONY: vm-build
vm-build:
	nixos-rebuild --impure build-vm

.PHONY: vm-run
vm-run: vm-build
	./result/bin/*

.PHONY: vm-build-virtualbox
vm-build-virtualbox:
	nixos-rebuild --impure build-vm-with-bootloader --image nixos.qcow2

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
	${NIX} profile remove --regex '.*dotfiles.*'
	${NIX} profile install --impure .
	{ [[ -f "${DMENU_CACHE}" ]] && rm "${DMENU_CACHE}"; true; }
	@[[ -f $$HOME/.cache/dmenu_run ]] \
		&& rm $$HOME/.cache/dmenu_run \
		&& dmenu_path > /dev/null

.PHONY: nix-update
nix-update:
	${NIX} flake update

.PHONY: gen-issue
gen-issue:
	cowsay -f turkey lmao | lolcat --force | sed -E 's|\\|\\\\|g' > root/etc/issue

.PHONY: fmt
fmt:
	./ci/format
