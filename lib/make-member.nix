{
  nixpkgs,
}:
{
  core,
  domain,
  inputs,
  manifests,
  members,
  name,
  self,
}:
memberName: member:
let
  inherit (nixpkgs) lib;

  manifest = manifests.${memberName};

  mkContainer = _: [
    { boot.isContainer = true; }
  ];

  kindModules =
    if manifest.kind == "container" then
      mkContainer member
    else
      throw "Unsupported host kind: ${manifest.kind}";
in
nixpkgs.lib.nixosSystem {
  inherit (manifest) system;

  modules = [
    {
      networking.hostName = lib.mkDefault manifest.identity.hostName;
      nixpkgs.config.allowUnfree = manifest.allowUnfree;
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion =
        manifest.stateVersion or (throw "Member '${memberName}': manifest.stateVersion is required");
    }
  ]
  ++ kindModules
  ++ core;

  specialArgs = {
    inherit
      inputs
      manifest
      memberName
      ;

    constellation = {
      inherit
        domain
        manifests
        members
        name
        ;
    };
  };
}
