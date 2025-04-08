{ pkgs, }:
with pkgs;
let
  src = fetchFromGitHub {
    owner = "weibeld";
    repo = "kubectl-ctx";
    rev = "84ce9a632d4cdc33dc31ce7a00bda1365b3707a7";
    sha256 = "sha256-ETXYwD8UI6PVus7L9OG7q28FBGGWLl0PaflPTWHMoRo=";
  };
in runCommand "kubectl-ctx" { } ''
  install -D -m 500 "${src}/kubectl-ctx" $out/bin/kubectl-ctx
''
