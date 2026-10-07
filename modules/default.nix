let
  modules = {
    dnsmasq = import ./dnsmasq.nix;
    hosts = import ./hosts.nix;
    syncthing = import ./syncthing.nix;
  };
in
modules
// {
  default = {
    imports = builtins.attrValues modules;
  };
}
