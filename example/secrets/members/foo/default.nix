_: {
  manifest = {
    network.addresses.vpn = "127.1.2.3";
    network.addresses.wan = "127.2.3.4";
  };

  modules = [
    ./configuration.nix
  ];

  users = [
    "example"
  ];
}
