let
  modules = {
    site = import ./site.nix;
    syncthing = import ./syncthing.nix;
  };
in
modules
// {
  default = {
    imports = builtins.attrValues modules;
  };
}
