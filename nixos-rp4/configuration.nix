{ config, lib, pkgs, ... }:
let
  mediaDir = "/media/96f47097-61e9-4234-b872-9daf8974b8dd";
in
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

  users.groups.media = {
    gid = 1001;
  };
  users.users.media = {
    group = "media";
    uid = 1001;
    isSystemUser = true;
  };

  environment.systemPackages = with pkgs; [
    bashmount
    curl
    fd
    git
    htop
    neofetch
    ripgrep
    vim
  ];

  environment.sessionVariables = {
    EDITOR = "vim";
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "0 0 * * * root journalctl --vacuum-size=5000M"
    ];
  };
  
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings.PasswordAuthentication = false;
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  services.transmission = {
    enable = true;
    openFirewall = true;
    openRPCPort = true;
    openPeerPorts = true;
    user = "media";
    settings = {
      download-dir =   "${mediaDir}/torrent";
      incomplete-dir = "${mediaDir}/torrent/.incomplete";
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false;
    };
  };

  services.dnsproxy = {
    enable = true;
    flags = [ "-v" "-u" "8.8.8.8:53" ];
  };

  # services.xserver.enable = true;

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
