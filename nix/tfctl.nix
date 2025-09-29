{ pkgs ? import <nixpkgs> { } }:
with pkgs;
buildGoModule rec {
  # TODO: Add version and hash to binary
  name = "tfctl";
  version = "0.15.1";
  src = fetchgit {
    url = "https://github.com/flux-iac/tofu-controller";
    rev = "v${version}";
    sha256 = "rA3HLO4sD8UmcebGGFxyg0zFpDHCzFHjHwMxPw8MiRU=";
  };
  subPackages = ["cmd/tfctl"];
  vendorHash = "sha256-NhXgWuxSuurP46DBWOviFzCINJKaTb1mINRYeYcnnH8=";
  env.CGO_ENABLED = 0;
}
