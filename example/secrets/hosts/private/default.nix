_: {
  kind = "nspawn";

  manifest = {
    identity.hostName = "private";
    network.addresses.lan = "10.233.123.10";
    stateVersion = "26.05";
    syncthing.id = "IFHVWR7-FDVH2QA-OUNAUZM-SFDUGBY-E4AWIQ5-NCGD3XX-2PZMXXS-HQXFIQN";
    system = "x86_64-linux";
  };

  modules = [
    ./configuration.nix
  ];
}
