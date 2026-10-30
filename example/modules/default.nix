let
  modules = {
    firewalld = import ./firewalld.nix;
    home-manager = import ./home-manager.nix;
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
