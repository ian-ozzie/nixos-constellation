_: {
  kind = "nspawn";

  manifest = {
    identity.hostName = "monitor";
    network.addresses.lan = "10.233.123.20";
    stateVersion = "26.05";
    system = "x86_64-linux";
  };

  modules = [
    ./configuration.nix
  ];
}
