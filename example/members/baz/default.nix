_: {
  manifest = {
    identity.hostName = "baz";
    kind = "nspawn";
    network.addresses.lan = "10.233.123.4";
    stateVersion = "26.05";
    system = "x86_64-linux";
  };

  modules = [
    ./configuration.nix
  ];
}
