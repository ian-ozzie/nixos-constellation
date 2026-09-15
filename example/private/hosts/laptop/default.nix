_: {
  facterReport = ./facter.json;

  manifest = {
    network.addresses.vpn = "127.12.2.3";
    network.addresses.wan = "127.21.3.4";
  };

  modules = [
    ./configuration.nix
  ];
}
