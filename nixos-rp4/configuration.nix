{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "nixos-rp4";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      ../id_rsa.pub
    ];
  };

  environment.systemPackages = with pkgs; [
    bashmount
    curl
    fd
    git
    neofetch
    ripgrep
    vim
  ];
  
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings.PasswordAuthentication = false;
  };

  services.transmission = {
    enable = true;
    openFirewall = true;
    openRPCPort = true;
    openPeerPorts = true;
    settings = {
      download-dir = "/media/96f47097-61e9-4234-b872-9daf8974b8dd/torrent";
      incomplete-dir = "/media/96f47097-61e9-4234-b872-9daf8974b8dd/torrent/.incomplete";
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false;
    };
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.udisks2 = {
    enable = true;
    mountOnMedia = true;
  };

  # environment.etc = {
  #   "test.conf" = {
  #     text = "test";
  #   };
  # };

  systemd.tmpfiles.rules = [
    "d /media 755 root root"
  ];

  # Don't change
  system.stateVersion = "23.11";
}
