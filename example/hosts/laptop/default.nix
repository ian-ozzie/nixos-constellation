{
  nixos-hardware,
  ...
}:
{
  kind = "metal";
  disko = ./storage.nix;

  manifest = {
    identity.hostName = "laptop";
    network.addresses.lan = "192.168.123.45";
    stateVersion = "26.05";
    system = "x86_64-linux";
  };

  modules = [
    nixos-hardware.nixosModules.framework-13-7040-amd

    ./configuration.nix
  ];
}
