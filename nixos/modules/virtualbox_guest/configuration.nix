{ config, lib, pkgs, rootDir, ... }: {
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.dragAndDrop = true;
  virtualisation.virtualbox.guest.clipboard = true;
  virtualisation.virtualbox.guest.vboxsf = true;

  users.users = builtins.foldl' (acc: x: acc // x) { }
    (map (user: { ${user} = { extraGroups = [ "vboxsf" ]; }; }) [
      "root"
      "user"
    ]);
}
