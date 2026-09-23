{
  nixpkgs,
}:
let
  inherit (nixpkgs) lib;

  makeMemberWith = import ./make-member.nix { inherit lib; };
  mergeMemberWith = import ./merge-member.nix { inherit lib; };
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
      discoverMembers = dir: lib.mapAttrs (_: path: import path inputs) (discoverDirs dir);
      manifests = lib.mapAttrs memberManifest members;
      memberNames = lib.unique (lib.attrNames publicMembers ++ lib.attrNames privateMembers);
      members = lib.genAttrs memberNames mergeMember;
      private = public.private or { };
      privateMembers = discoverFrom private "membersDir" discoverMembers;
      privateProjects = discoverFrom private "projectsDir" discoverDirs;
      privateUsers = discoverFrom private "usersDir" discoverDirs;
      projectPaths = publicProjects // privateProjects;
      public = import (root + "/constellation.nix") inputs;
      publicMembers = discoverFrom public "membersDir" discoverMembers;
      publicProjects = discoverFrom public "projectsDir" discoverDirs;
      publicUsers = discoverFrom public "usersDir" discoverDirs;
      services = lib.recursiveUpdate (public.services or { }) (private.services or { });
      userNames = lib.unique (lib.attrNames publicUsers ++ lib.attrNames privateUsers);

      constellationUsers =
        let
          users = lib.unique ((public.users or [ ]) ++ (private.users or [ ]));
          unknown = lib.filter (userName: !(userPaths ? ${userName})) users;
        in
        if unknown == [ ] then
          users
        else
          throw "Constellation '${name}': unknown users: ${lib.concatStringsSep ", " unknown}";

      discoverDirs =
        dir:
        let
          entries = builtins.readDir dir;

          dirs = lib.filterAttrs (
            dirName: type: type == "directory" && builtins.pathExists (dir + "/${dirName}/default.nix")
          ) entries;
        in
        lib.mapAttrs (dirName: _: dir + "/${dirName}") dirs;

      discoverFrom =
        source: key: discover:
        if source ? ${key} then discover source.${key} else { };

      makeMember = makeMemberWith {
        inherit
          core
          domain
          inputs
          manifests
          members
          name
          projectModules
          self
          services
          userModules
          ;
      };

      memberManifest =
        memberName: member:
        lib.recursiveUpdate {
          allowUnfree = false;
          identity.hostName = memberName;
          system = "x86_64-linux";
        } (member.manifest or { });

      mergeMember = mergeMemberWith {
        inherit
          privateMembers
          publicMembers
          ;
      };

      projectDefinitions = lib.mapAttrs (
        projectName: settings:
        let
          project = {
            inherit domain;

            subdomain = projectName;
          }
          // settings;

          path =
            projectPaths.${projectName} or (throw "Project '${projectName}': no project directory found");
        in
        import path {
          inherit
            inputs
            projectName
            project
            ;
        }
      ) projects;

      projectModules = lib.genAttrs memberNames (
        memberName:
        lib.concatLists (
          lib.mapAttrsToList (
            projectName: project:
            lib.mapAttrsToList (roleName: _: projectRole projectName roleName) (
              lib.filterAttrs (_: role: lib.elem memberName (lib.toList role)) (project.roles or { })
            )
          ) projects
        )
      );

      projectRole =
        projectName: roleName:
        projectDefinitions.${projectName}.${roleName}
          or (throw "Project '${projectName}': role '${roleName}' is not defined in ${
            toString projectPaths.${projectName}
          }");

      projects = lib.mapAttrs (
        projectName: project:
        let
          assignments = lib.concatLists (
            lib.mapAttrsToList (
              roleName: role: map (memberName: { inherit memberName roleName; }) (lib.toList role)
            ) (project.roles or { })
          );

          unknown = lib.filter (assignment: !(members ? ${assignment.memberName})) assignments;
        in
        if unknown == [ ] then
          project
        else
          throw "Project '${projectName}': unknown member assignments: ${
            lib.concatMapStringsSep ", " (
              assignment: "${assignment.roleName} -> ${assignment.memberName}"
            ) unknown
          }"
      ) (lib.recursiveUpdate (public.projects or { }) (private.projects or { }));

      userModules = lib.genAttrs memberNames (
        memberName:
        let
          users = lib.unique (constellationUsers ++ (members.${memberName}.users or [ ]));
          unknown = lib.filter (userName: !(userPaths ? ${userName})) users;
        in
        if unknown == [ ] then
          lib.concatMap (userName: userPaths.${userName}) users
        else
          throw "Member '${memberName}': unknown users: ${lib.concatStringsSep ", " unknown}"
      );

      userPaths = lib.genAttrs userNames (
        userName:
        lib.optional (publicUsers ? ${userName}) publicUsers.${userName}
        ++ lib.optional (privateUsers ? ${userName}) privateUsers.${userName}
      );
    in
    {
      nixosConfigurations = lib.mapAttrs makeMember members;
    };
}
