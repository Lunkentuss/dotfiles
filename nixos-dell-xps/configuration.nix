{ config, lib, pkgs, inputs, packages, ... }:
let
  sourceCodeProRepo = pkgs.fetchgit {
    url = "https://github.com/adobe-fonts/source-code-pro.git";
    rev = "d3f1a59";
    sha256 = "sha256-Pl7cuBFtbk9tPv421ejKnKFKdsW6oezMnAGCWKI3OVY=";
  };
  home = ../home;
  # https://tinted-theming.github.io/tinted-gallery/
  theme = "eighties";
in {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-dell-xps";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "sv_SE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkb.variant = "";
    displayManager.startx.enable = true;
    windowManager.bspwm.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "se";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  virtualisation.docker.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  services.pipewire = {
    enable = false;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "docker" ];
    packages = packages;
  };

  environment.systemPackages = packages;
  environment.etc = {
    issue.source = ../root/etc/issue;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = false;

  home-manager = {
    users = {
      user = {

       imports = [
         inputs.nixvim.homeManagerModules.nixvim
       ];

        xsession.windowManager.bspwm = {
       	  enable = true;
       	  extraConfig = builtins.readFile (home + "/.config/bspwm/_bspwmrc");
        };

        # Enable notifications
        services.dunst = {
          enable = true;
        };

        programs.nixvim = {
          enable = true;
        };

        # This makes sure stylix injects the theme, in contrast to simply copying the config
        programs.alacritty = {
          enable = true;
          settings = builtins.fromTOML
            (builtins.readFile (home + "/.config/alacritty/_alacritty.toml"));
        };

        programs.k9s.enable = true;
        programs.zathura.enable = true;
        programs.rofi.enable = true;
        programs.fzf.enable = true;

        xresources.properties = {
          "Xft.dpi" = "110";
          "Xft.rgba" = "none";
          "Xft.hintstyle" = "hintslight";
        };

        home = {
          stateVersion = "24.11";

          # We have to make an exception for .config, since home manager saves files in this directory.
          file = {
            "Pictures" = {
              source = ../images;
              recursive = true;
            };
            ".config" = {
              source = home + "/.config";
              recursive = true;
            };
            ".local/share/fonts/ttf/SourceCodePro" = {
              source = sourceCodeProRepo + "/TTF";
            };
          } // builtins.listToAttrs (map (name: {
            name = name;
            value = { source = home + "/${name}"; };
          }) (builtins.filter (name: name != ".config")
            ((builtins.attrNames (builtins.readDir home)))));
        };
      };
    };
  };

  stylix.enable = true;
  stylix.base16Scheme =
    "${pkgs.base16-schemes}/share/themes/${theme}.yaml";

  stylix.image = pkgs.fetchurl {
    # Placeholder, not really used. Black background for now.
    url =
      "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  };

  environment.sessionVariables = {
    "EDITOR" = "nvim";
  };

  # Don't change
  system.stateVersion = "24.11";
}
