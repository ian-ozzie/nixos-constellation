{
  config,
  constellation,
  lib,
  memberName,
  ...
}:
let
  cfg = config.ozzie.constellation.hosts;

  hostsWith =
    network:
    let
      hosts = lib.filterAttrs (
        peerName: manifest:
        (manifest.network.addresses.${network} or null) != null && peerName != memberName
      ) constellation.manifests;

      grouped = lib.groupBy (manifest: manifest.network.addresses.${network}) (lib.attrValues hosts);
    in
    lib.mapAttrs (_: manifests: map (manifest: manifest.identity.hostName) manifests) grouped;
in
{
  options.ozzie.constellation.hosts = {
    enable = lib.mkEnableOption "write constellation hosts";

    network = lib.mkOption {
      default = "lan";
      description = "network name to use for hosts";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.hosts = hostsWith cfg.network;
  };
}
