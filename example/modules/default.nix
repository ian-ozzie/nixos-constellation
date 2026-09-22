let
  modules = {
    firewalld = import ./firewalld.nix;
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
