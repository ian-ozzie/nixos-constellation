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
      inherit (public) domain name;

      core = (public.core or [ ]) ++ (private.core or [ ]);
      manifests = lib.mapAttrs memberManifest members;
      members = lib.genAttrs hostNames mergeMember;
      private = lib.recursiveUpdate privateDefaults (public.private or { });
      privateMembers = if private ? hostsDir then discoverMembers private.hostsDir else { };
      public = import (root + "/constellation.nix") inputs;
      publicMembers = if public ? hostsDir then discoverMembers public.hostsDir else { };

      discoverMembers =
        dir:
        let
          entries = builtins.readDir dir;

          hosts = lib.filterAttrs (
            name: type: type == "directory" && builtins.pathExists (dir + "/${name}/default.nix")
          ) entries;
        in
        lib.mapAttrs (name: _: import (dir + "/${name}") inputs) hosts;

      hostNames = lib.unique (lib.attrNames publicMembers ++ lib.attrNames privateMembers);

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
        inherit
          privateMembers
          publicMembers
          ;
      };

      privateDefaults = {
        core = [ ];
      };
    in
    {
      nixosConfigurations = lib.mapAttrs makeMember members;
    };
}
