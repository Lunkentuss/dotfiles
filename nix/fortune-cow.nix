{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  script = writeShellScriptBin "fortune-cow" ''
    ${fortune}/bin/fortune | ${cowsay}/bin/cowsay $@ | ${lolcat}/bin/lolcat
  '';
in script
