_: {
  kind = "nspawn";

  manifest = {
    identity.hostName = "foo";
    network.addresses.lan = "10.233.123.2";
    stateVersion = "26.05";
    syncthing.id = "ETQRYC7-YJYFGAL-QXQWYFO-HZODD6K-JYHLCID-UMUJVG4-O6LLW7D-JNK6FAB";
    system = "x86_64-linux";
  };

  modules = [
    ./configuration.nix
  ];
}
