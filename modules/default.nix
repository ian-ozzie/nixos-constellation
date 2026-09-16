let
  modules = {
    hosts = import ./hosts.nix;
  };
in
modules
// {
  default = {
    imports = builtins.attrValues modules;
  };
}
