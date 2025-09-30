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
  vendorHash = "sha256-NhXgWuxSuurP46DBWOviFzCINJKaTb1mINRYeYcnnH8=";

  subPackages = ["cmd/tfctl"];
  ldflags = [
    "-X main.BuildSHA=${src.rev}"
    "-X main.BuildVersion=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for shell in bash zsh fish ; do
      $out/bin/tfctl completion "$shell" > "tfctl.$shell"
    done

    installShellCompletion tfctl.{bash,zsh,fish}
  '';

  meta = with lib; {
    homepage = "https://github.com/flux-iac/tofu-controller";
    description = "Cli for managing tofu-controller";
    mainProgram = "tfctl";
    license = licenses.asl20;
    maintainers = with maintainers; [
      lunkentuss
    ];
  };
}
