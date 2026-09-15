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

  kind = member.kind or "container";
  manifest = manifests.${memberName};

  mkContainer = _: [
    {
      boot.isContainer = true;
    }
  ];

  mkMetal = member: [
    {
      hardware.facter.reportPath = member.facterReport;
    }
  ];

  kindModules =
    if kind == "container" then
      mkContainer member
    else if kind == "metal" then
      mkMetal member
    else
      throw "Unsupported host kind: ${kind}";
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
  ++ core
  ++ (member.modules or [ ]);

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
