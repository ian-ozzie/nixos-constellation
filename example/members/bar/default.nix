_: {
  manifest = {
    identity.hostName = "bar";
    kind = "nspawn";
    network.addresses.lan = "10.233.123.3";
    stateVersion = "26.05";
    syncthing.id = "4PRFDL2-EDTSXJ4-AVHV3S6-ND5IOQZ-2GBCC3M-KAJGDTL-6H3KDXQ-LIMIZQC";
    system = "x86_64-linux";
  };

  modules = [
    ./configuration.nix
  ];
}
