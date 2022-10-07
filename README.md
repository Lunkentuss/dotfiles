# dotfiles

- Editor: [neovim](https://github.com/neovim/neovim)
- OS: [arch linux](https://archlinux.org/)
- Terminal: [alacritty](https://github.com/alacritty/alacritty)
- Theme: [solarized](https://ethanschoonover.com/solarized/)
- WM: [bspwm](https://github.com/baskerville/bspwm)
- Packages manager: [pacman](https://github.com/weynhamz/Arch-pacman) & [nix](https://github.com/NixOS/nix)

## Using the nix flake for installing packages
Additionally to my configuration files, this repository contains all of my
installed packages using the nix package manager. External users can install
all the packages by using the flake feature in nix. Assuming the nix version
has support for flakes (version > 2.04), and the `nix-command` and `flakes`
experimental features have been enabled, the packages can be installed with:

```bash
nix profile install github:lunkentuss/dotfiles
```

To test that the binaries have been properly installed, you can run:


```bash
fortune-cow
```

and you'll see something like:

```
 ________________________________
< Heisenberg may have been here. >
 --------------------------------
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

Alternatively, the packages can be installed in the provided `Dockerfile`, by building
and running the `Dockerfile` with:

```bash
docker run -ti --entrypoint /bin/sh $(docker build -q .)
```
