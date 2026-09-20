{
  sops-nix,
  ...
}:
{
  kind = "nspawn";

  manifest = {
    identity.hostName = "bar";
    network.addresses.lan = "10.233.123.3";
    stateVersion = "26.05";
    system = "x86_64-linux";
    syncthing.id = "4PRFDL2-EDTSXJ4-AVHV3S6-ND5IOQZ-2GBCC3M-KAJGDTL-6H3KDXQ-LIMIZQC";
  };

  modules = [
    sops-nix.nixosModules.sops

    ./configuration.nix
  ];
}
