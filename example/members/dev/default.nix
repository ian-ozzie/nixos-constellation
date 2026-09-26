_: {
  kind = "nspawn";

  manifest = {
    identity.hostName = "dev";
    stateVersion = "26.05";
    syncthing.id = "ETQRYC7-YJYFGAL-QXQWYFO-HZODD6K-JYHLCID-UMUJVG4-O6LLW7D-JNK6FAB";
    system = "x86_64-linux";

    network.addresses = {
      internal = "127.0.0.1";
      lan = "10.233.123.100";
    };
  };

  modules = [
    ./configuration.nix
  ];
}
