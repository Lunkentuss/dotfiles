{ config, lib, pkgs, rootDir, ... }: {
  services.qemuGuest.enable = lib.mkForce true;
  services.spice-vdagentd.enable = lib.mkForce true;
}
