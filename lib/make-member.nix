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
  projectModules,
  self,
  services,
  userModules,
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

  mkMetal =
    member:
    [
      {
        hardware.facter.reportPath =
          member.facterReport or (throw "Member '${memberName}': facterReport is required");
      }
    ]
    ++ lib.optionals (member ? disko) [
      (inputs.disko or (throw "Member '${memberName}': the 'disko' flake input is required"))
      .nixosModules.disko

      member.disko
    ];

  mkNspawn = _: [
    {
      boot.isNspawnContainer = true;
    }
  ];

  kindModules =
    if kind == "container" then
      mkContainer member
    else if kind == "metal" then
      mkMetal member
    else if kind == "nspawn" then
      mkNspawn member
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
  ++ (member.modules or [ ])
  ++ projectModules.${memberName}
  ++ userModules.${memberName};

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
        services
        ;
    };
  };
}
