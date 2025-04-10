{ config, lib, pkgs, inputs, packages, rootDir, ... }:
let
  sourceCodeProRepo = pkgs.fetchgit {
    url = "https://github.com/adobe-fonts/source-code-pro.git";
    rev = "d3f1a59";
    sha256 = "sha256-Pl7cuBFtbk9tPv421ejKnKFKdsW6oezMnAGCWKI3OVY=";
  };
  homeDir = rootDir + "/home";
  # https://tinted-theming.github.io/tinted-gallery/
  theme = "eighties";
  emptyHashedPassword =
    "$6$q2mvN2/cRoRFPuKp$DeFijIG2QsjysPMajtHUUavdk7St/FqXg0HejIpW1CsaqrlfDkLZ2tERX7CF.PeA0Zxw51LJnFrjEpohTbt7l/";
in {
  imports = [
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
    # Use libinput instead for now.
    # synaptics = {
    #   enable = true;
    #   palmDetect = true;
    # };
  };

  services.libinput = {
    enable = true;
    touchpad.disableWhileTyping = true;
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "se";
  services.xserver.xkb.options = "eurosign:e,caps:escape";

  virtualisation.docker.enable = true;
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user" ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  services.pipewire = {
    enable = false;
    pulse.enable = true;
  };

  users.users.root = { initialHashedPassword = emptyHashedPassword; };

  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "docker" ];
    packages = packages;
    initialHashedPassword = emptyHashedPassword;
  };

  environment.systemPackages = packages;
  environment.etc = { issue.source = rootDir + "/root/etc/issue"; };

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

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  programs.steam.enable = true;
  hardware.xpadneo.enable = true;

  home-manager = {
    users = {
      user = {

        imports = [ inputs.nixvim.homeManagerModules.nixvim ];

        xsession.windowManager.bspwm = {
          enable = true;
          extraConfig = builtins.readFile (homeDir + "/.config/bspwm/_bspwmrc");
        };

        # Enable notifications
        services.dunst = { enable = true; };

        programs.nixvim = {
          enable = true;
          plugins = {
            lualine.enable = true;
            telescope.enable = true;
            treesitter.enable = true;
            nvim-surround.enable = true;
            commentary.enable = true;
            cmp = {
              enable = true;
              autoEnableSources = true;
              settings = {
                sources = [ { name = "nvim_lsp"; } { name = "luasnip"; } ];
              };
            };
            cmp-nvim-lsp.enable = true;
            luasnip.enable = true;

            lsp = {
              enable = true;
              servers = {
                bashls.enable = true;
                pylsp.enable = true;
                jsonls.enable = true;
                gopls.enable = true;
                jsonnet_ls.enable = true;
                terraformls.enable = true;
                nixd.enable = true;
                rust_analyzer = {
                  enable = true;
                  installCargo = false;
                  installRustc = false;
                };
              };
              onAttach = ''
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

                local bufopts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
                vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
                vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
                vim.keymap.set("n", "<leader>wl", function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, bufopts)
                vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
                vim.keymap.set("n", "<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, bufopts)
              '';
            };

            # Intrinsic dependencies
            web-devicons.enable = true;
          };
          extraConfigLua =
            builtins.readFile (homeDir + "/.config/nvim/_init.lua");
        };

        # This makes sure stylix injects the theme, in contrast to simply copying the config
        programs.alacritty = {
          enable = true;
          settings = builtins.fromTOML (builtins.readFile
            (homeDir + "/.config/alacritty/_alacritty.toml"));
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
              source = rootDir + "/images";
              recursive = true;
            };
            ".config" = {
              source = homeDir + "/.config";
              recursive = true;
            };
            ".local/share/fonts/ttf/SourceCodePro" = {
              source = sourceCodeProRepo + "/TTF";
            };
          } // builtins.listToAttrs (map (name: {
            name = name;
            value = { source = homeDir + "/${name}"; };
          }) (builtins.filter (name: name != ".config")
            ((builtins.attrNames (builtins.readDir homeDir)))));
        };
      };
    };
  };

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";

  stylix.image = pkgs.fetchurl {
    # Placeholder, not really used. Black background for now.
    url =
      "https://www.pixelstalk.net/wp-content/uploads/2016/05/Epic-Anime-Awesome-Wallpapers.jpg";
    sha256 = "enQo3wqhgf0FEPHj2coOCvo7DuZv+x5rL/WIo4qPI50=";
  };

  environment.sessionVariables = { "EDITOR" = "nvim"; };

  # Don't change
  system.stateVersion = "24.11";
}
