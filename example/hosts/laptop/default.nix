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
    syncthing.id = "WEWPHZR-HRNJP4H-FQKI2LN-3PFZCCU-YSXINGM-GYIILL2-KKG3ZOS-BY67SAD";
  };

  modules = [
    nixos-hardware.nixosModules.framework-13-7040-amd

    ./configuration.nix
  ];
}
