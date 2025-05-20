{ config, lib, pkgs, inputs, hostname, packages, rootDir, customConfig, ... }:
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

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  security.pki.certificateFiles = lib.pipe (rootDir + "/ca") [
    builtins.readDir
    builtins.attrNames
    (builtins.filter (file: file != "README.md"))
    (lib.map (file: rootDir + "/ca/${file}"))
  ];

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
    xkb.variant = "nodeadkeys";
    displayManager.startx.enable = true;
    # windowManager.bspwm.enable = true;
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Configurations for enabling support for accessing iOS devices.
  services.usbmuxd = {
    enable = true;
    package = pkgs.usbmuxd2;
  };
  services.gvfs.enable = true;
  programs.gphoto2.enable = true;

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

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
      xorg.libX11
      xorg.libXcursor
      xorg.libxcb
      xorg.libXi
      libxkbcommon
      alsa-lib
      udev
      vulkan-loader
      xorg.libXrandr
  ];

  home-manager = {
    users = {
      user = {

        imports = [ inputs.nixvim.homeManagerModules.nixvim ];

        programs.bash = {
          enable = true;
          profileExtra = builtins.readFile (homeDir + "/.bash_profile");
          bashrcExtra = builtins.readFile (homeDir + "/.bashrc");
        };

        xsession.enable = true;
        xsession.profileExtra = ''
          ${pkgs.sxhkd}/bin/sxhkd &
        '';
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
            treesitter = {
              enable = true;
              settings = {
                highlight = {
                  enable  = true;
                };
              };
            };
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
            ".local/share/fonts/ttf/SourceCodePro" = {
              source = sourceCodeProRepo + "/TTF";
            };
            ".gitconfig-work" = {
              source = pkgs.runCommand "gitconfig-custom" {} ''
                sed -E "s/WORK_EMAIL/${customConfig.workEmail}/g" "${homeDir + "/.gitconfig-work"}" > $out
              '';
            };
          } // (
            # Copy directories
            lib.pipe homeDir [
              builtins.readDir
              (lib.filterAttrs (name: value: value == "directory"))
              builtins.attrNames
              (map (name: {
                name = name;
                value = {
                  source = homeDir + "/${name}";
                  # We make bin only readable for security reasons
                  recursive = !(builtins.elem name [ "bin" ]);
                };
              }))
              builtins.listToAttrs
            ]) // (
              # Copy regular files
              lib.pipe homeDir [
                builtins.readDir
                (lib.filterAttrs (name: value: value == "regular"))
                builtins.attrNames
                (builtins.filter
                  (name: !(builtins.elem name [ ".bash_profile" ".bashrc" ".gitconfig-work" ])))
                (map (name: {
                  name = name;
                  value = { source = homeDir + "/${name}"; };
                }))
                builtins.listToAttrs
              ]);
        };
      };
    };
  };

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/${theme}.yaml";

  stylix.image = rootDir + "/images/kyoto.avif";

  environment.sessionVariables = { "EDITOR" = "nvim"; };

  # Don't change
  system.stateVersion = "24.11";
}
