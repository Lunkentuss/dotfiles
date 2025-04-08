{ pkgs ? import <nixpkgs> { } }:
with pkgs;
buildGoModule {
  name = "jksutil";
  version = "0.1.0";
  src = fetchgit {
    url = "https://github.com/GoogleContainerTools/distroless.git";
    rev = "2e0344cb8e092177a75babf5be1d5699e31bb2c5";
    sha256 = "sha256-TyqSTZiMxqcURrOq2es3Ia9GQgbyp2QgbQlmcxhxi7s=";
  } + "/cacerts/jksutil";
  vendorHash = null;
  preBuild = ''
    go mod init jksutil
  '';
  CGO_ENABLED = 0;
}
