{ config, lib, pkgs, inputs, rootDir, ... }:
with pkgs; {
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;
  environment.systemPackages = [
    (writeShellScriptBin "nixos-bootstrap" (rootDir + "/nixos-bootstrap"))
    git
  ];
}
