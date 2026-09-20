{
  config,
  constellation,
  lib,
  manifest,
  memberName,
  ...
}:
let
  cfg = config.ozzie.constellation.syncthing;
  deviceName = device: if builtins.isString device then device else device.name;
  devices = removeAttrs (lib.recursiveUpdate memberDevices (shared.devices or { })) [ memberName ];
  shared = constellation.services.syncthing or { };

  folders = lib.mapAttrs (
    _: folder:
    folder
    // {
      devices = builtins.filter (device: deviceName device != memberName) folder.devices;
    }
  ) memberFolders;

  memberDevices = lib.mapAttrs (_: manifest: {
    id = manifest.syncthing.id;
    addresses = map (
      address: "tcp://${if lib.hasInfix ":" address then "[${address}]" else address}:22000"
    ) (lib.filter (address: address != null) (lib.attrValues (manifest.network.addresses or { })));
  }) syncthingMembers;

  memberFolders = lib.filterAttrs (
    _: folder: builtins.any (device: deviceName device == memberName) (folder.devices or [ ])
  ) (shared.folders or { });

  syncthingMembers = lib.filterAttrs (
    _: manifest: (manifest.syncthing.id or null) != null
  ) constellation.manifests;
in
{
  options.ozzie.constellation.syncthing = {
    enable = lib.mkEnableOption "constellation syncthing configuration";
  };

  config = lib.mkIf (cfg.enable && (manifest.syncthing.id or null) != null) {
    services.syncthing = {
      enable = true;

      settings = {
        inherit devices folders;
      };
    };
  };
}
