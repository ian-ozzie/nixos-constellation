_: {
  manifest = {
    identity.hostName = "monitor";
    kind = "nspawn";
    network.addresses.lan = "10.233.123.20";
    stateVersion = "26.05";
    system = "x86_64-linux";
  };

  modules = [
    ./configuration.nix
  ];
}
