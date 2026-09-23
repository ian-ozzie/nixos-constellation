{
  lib,
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
  kind = member.kind or "container";
  manifest = manifests.${memberName};

  kindModules =
    if kind == "container" then
      [
        {
          boot.isContainer = true;
        }
      ]
    else if kind == "metal" then
      [
        {
          hardware.facter.reportPath =
            member.facterReport or (throw "Member '${memberName}': 'facterReport' is required");
        }
      ]
      ++ lib.optionals (member ? disko) [
        (inputs.disko or (throw "Member '${memberName}': the 'disko' flake input is required"))
        .nixosModules.disko

        member.disko
      ]
    else if kind == "nspawn" then
      [
        {
          boot.isNspawnContainer = true;
        }
      ]
    else
      throw "Member '${memberName}': unsupported 'kind': ${kind}";
in
lib.nixosSystem {
  inherit (manifest) system;

  modules = [
    {
      networking.hostName = lib.mkDefault manifest.identity.hostName;
      nixpkgs.config.allowUnfree = manifest.allowUnfree;
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion =
        manifest.stateVersion or (throw "Member '${memberName}': 'manifest.stateVersion' is required");
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
