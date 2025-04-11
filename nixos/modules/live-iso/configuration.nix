{ config, lib, pkgs, inputs, rootDir, ... }:
with pkgs; {
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = [
    (writeShellScriptBin "nixos-bootstrap" (rootDir + "/nixos-bootstrap"))
    git
  ];
}
