{ pkgs ? import <nixpkgs> { } }:
with pkgs;
jrsonnet.overrideAttrs (
  old: rec {
    cargoBuildFlags = old.cargoBuildFlags or [] ++ [ "--features=exp-preserve-order"  ];
    version = "v0.5.0-pre96-test";
    src = fetchFromGitHub {
      rev = "v0.5.0-pre96-test";
      owner = "CertainLach";
      repo = "jrsonnet";
      sha256 = "sha256-dm62UkL8lbvU3Ftjj6K5ziZGuHpFyLUzyTg9x/+no54=";
    };
    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit src;
      hash = "sha256-ZHmdlqakucapzXJz6L7ZJpmvqTutelN8qkWAD4uDJr8=";
    };
    # Newer version is using generate cmd instead of --generate fla
    # to geneerate shell completion.
    postInstall = ''
      ln -s $out/bin/jrsonnet $out/bin/jsonnet
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash zsh fish; do
      installShellCompletion --cmd jrsonnet \
        --$shell <($out/bin/jrsonnet generate $shell)
      installShellCompletion --cmd jsonnet \
        --$shell <($out/bin/jrsonnet generate $shell | sed s/jrsonnet/jsonnet/g)
    done
    '';
  })
