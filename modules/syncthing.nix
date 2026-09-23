{
  config,
  constellation,
  inputs,
  lib,
  manifest,
  memberName,
  ...
}:
let
  allDevices = lib.recursiveUpdate memberDevices (shared.devices or { });
  cfg = config.ozzie.constellation.syncthing;
  deviceName = device: if lib.isString device then device else device.name;
  devices = removeAttrs allDevices [ memberName ];
  enabled = cfg.enable && (manifest.syncthing.id or null) != null;
  shared = constellation.services.syncthing or { };

  folders = lib.mapAttrs (
    _: folder:
    folder
    // {
      devices = lib.filter (device: deviceName device != memberName) folder.devices;
    }
  ) memberFolders;

  memberDevices = lib.mapAttrs (
    _: peer:
    let
      addresses = peer.network.addresses or { };

      selected =
        if cfg.networks == null then
          lib.attrValues addresses
        else
          map (network: addresses.${network} or null) cfg.networks;
    in
    {
      id = peer.syncthing.id;
      addresses = map (
        address: "tcp://${if lib.hasInfix ":" address then "[${address}]" else address}:22000"
      ) (lib.filter (address: address != null) selected);
    }
  ) syncthingMembers;

  memberFolders = lib.filterAttrs (
    _: folder: lib.any (device: deviceName device == memberName) (folder.devices or [ ])
  ) (shared.folders or { });

  syncthingMembers = lib.filterAttrs (
    _: peer: (peer.syncthing.id or null) != null
  ) constellation.manifests;
in
{
  options.ozzie.constellation.syncthing = {
    enable = lib.mkEnableOption "constellation syncthing configuration";

    networks = lib.mkOption {
      default = null;
      description = "member network addresses to specify";
      example = [ "lan" ];
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
    };
  };

  config = lib.mkMerge [
    (lib.mkIf enabled {
      assertions = lib.mapAttrsToList (
        name: folder:
        let
          unknown = lib.filter (device: !(allDevices ? ${device})) (map deviceName (folder.devices or [ ]));
        in
        {
          assertion = unknown == [ ];
          message = "Syncthing folder '${name}': unknown devices: ${lib.concatStringsSep ", " unknown}";
        }
      ) (shared.folders or { });

      services.syncthing = {
        enable = true;

        settings = {
          inherit devices folders;
        };
      };
    })

    (lib.optionalAttrs (inputs ? ozzie-lab) {
      ozzie.lab.syncthing.enable = lib.mkIf enabled true;
    })
  ];
}
