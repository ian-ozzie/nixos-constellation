{
  nixpkgs,
}:
let
  inherit (nixpkgs) lib;

  makeMemberWith = import ./make-member.nix { inherit nixpkgs; };
  mergeMemberFor = import ./merge-member.nix { inherit lib; };
in
{
  mkConstellation =
    {
      self,
      inputs,
      root ? self,
    }:
    let
      inherit (constellation) domain name;

      constellation = import (root + "/constellation.nix") inputs;
      core = (constellation.core or [ ]) ++ (private.core or [ ]);
      private = lib.recursiveUpdate privateDefaults (constellation.private or { });
      members = lib.genAttrs hostNames mergeMember;
      manifests = lib.mapAttrs memberManifest members;

      hostNames = lib.unique (
        lib.attrNames (constellation.members or { }) ++ lib.attrNames private.members
      );

      makeMember = makeMemberWith {
        inherit
          core
          domain
          inputs
          manifests
          members
          name
          self
          ;
      };

      memberManifest =
        memberName: member:
        lib.recursiveUpdate {
          allowUnfree = false;
          identity.hostName = memberName;
          system = "x86_64-linux";
        } (member.manifest or { });

      mergeMember = mergeMemberFor {
        inherit constellation private;
      };

      privateDefaults = {
        core = [ ];
        members = { };
      };
    in
    {
      nixosConfigurations = lib.mapAttrs makeMember members;
    };
}
