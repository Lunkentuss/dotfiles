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

# Listing generations can be done with the following:
# nix profile history --profile /nix/var/nix/profiles/system
.PHONY: nixos-remove-old-generations
nixos-remove-old-generations:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 14d
	nix store gc

.PHONY: vm-build
vm-build:
	nixos-rebuild --impure build-vm

.PHONY: vm-run
vm-run: vm-build
	./result/bin/*

# All available formats can be found here:
# https://github.com/nix-community/nixos-generators?tab=readme-ov-file#supported-formats
.PHONY: vm-build-virtualbox
vm-build-virtualbox:
	nix build --impure .#nixosConfigurations.nixos-desktop-vm.config.formats.virtualbox

# Builds a live image iso image used to bootstrap a nixos installation. It
# contains the usual nixos iso image tools and some extra utilities.
# Run the following to write it to a drive
# dd if=nixos.iso of=/dev/sdX bs=4M status=progress conv=fdatasync
.PHONY: live-iso-image
live-iso-image:
	nix build --impure .#nixosConfigurations.live-iso.config.system.build.isoImage
	@echo "Success!"
	@echo "Run the following and substitute the block device:"
	@echo 'dd if=$$(echo "$$PWD/result/iso/"*) of=/dev/sdXXX bs=4M status=progress conv=fdatasync'

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
