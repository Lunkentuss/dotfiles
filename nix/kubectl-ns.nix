{ pkgs, }:
with pkgs;
let
  src = fetchFromGitHub {
    owner = "weibeld";
    repo = "kubectl-ns";
    rev = "2a031156ddcc513493460f6fa85a47c746a255f9";
    sha256 = "sha256-Qs5iZ4JwtC7jxjq9QhVnjohokxJd2sSdCCYg19DUN9o=";
  };
in runCommand "kubectl-ns" { } ''
  install -D -m 500 "${src}/kubectl-ns" $out/bin/kubectl-ns
''
