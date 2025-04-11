{ config, lib, pkgs, rootDir, ... }:
{
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "root" "user" ];
}
