# dotfiles

![nixos](/images/nixos.png)

- Editor: [neovim](https://github.com/neovim/neovim)
- OS: [nixos](https://nixos.org/)
- Terminal: [alacritty](https://github.com/alacritty/alacritty)
- Theme: [eighties](https://tinted-theming.github.io/tinted-gallery/#base16-eighties)
- WM: [bspwm](https://github.com/baskerville/bspwm)

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

Alternatively, the packages can be tested with an OCI image which can be built
from the provided `Dockerfile`, by building and running the `Dockerfile` with:

```bash
docker run -ti --entrypoint /bin/sh $(docker build -q .)
```
