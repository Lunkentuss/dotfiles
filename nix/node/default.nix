pkgs:
with pkgs;
mkYarnPackage {
  name = "yarn-packages";
  src = ./.;
  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
}
