{
  nixpkgs,
}:
let
  inherit (nixpkgs) lib;

  makeMemberWith = import ./make-member.nix { inherit lib; };
  mergeSettings = import ./merge-settings.nix { inherit lib; };
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
      projectNames = lib.unique (lib.attrNames publicProjects ++ lib.attrNames privateProjects);
      public = import (root + "/constellation.nix") inputs;
      publicMembers = discoverFrom public "membersDir" discoverMembers;
      publicProjects = discoverFrom public "projectsDir" discoverDirs;
      publicUsers = discoverFrom public "usersDir" discoverDirs;
      services = mergeSettings (public.services or { }) (private.services or { });
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

          system =
            if member ? facterReport then (lib.importJSON member.facterReport).system else "x86_64-linux";
        } (member.manifest or { });

      mergeMember =
        memberName:
        mergeSettings (publicMembers.${memberName} or { }) (privateMembers.${memberName} or { });

      projectAssignments =
        let
          assignments = lib.concatLists (
            lib.mapAttrsToList (
              projectName: project:
              lib.concatLists (
                lib.mapAttrsToList (
                  roleName: role: map (memberName: { inherit memberName projectName roleName; }) (lib.toList role)
                ) (project.roles or { })
              )
            ) projects
          );

          unknown = map (
            assignment: "${assignment.projectName}.${assignment.roleName} -> ${assignment.memberName}"
          ) (lib.filter (assignment: !(members ? ${assignment.memberName})) assignments);
        in
        if unknown == [ ] then
          assignments
        else
          throw "Constellation '${name}': unknown member assignments: ${lib.concatStringsSep ", " unknown}";

      projectDefinitions = lib.mapAttrs (
        projectName: settings:
        let
          project = {
            inherit domain;

            subdomain = projectName;
          }
          // settings;
        in
        map (path: import path { inherit project projectName; }) projectPaths.${projectName}
      ) projects;

      projectModules = lib.genAttrs memberNames (
        memberName:
        lib.concatMap (assignment: projectRole assignment.projectName assignment.roleName) (
          lib.filter (assignment: assignment.memberName == memberName) projectAssignments
        )
      );

      projectPaths = lib.genAttrs projectNames (
        projectName:
        lib.optional (publicProjects ? ${projectName}) publicProjects.${projectName}
        ++ lib.optional (privateProjects ? ${projectName}) privateProjects.${projectName}
      );

      projectRole =
        projectName: roleName:
        let
          roles = lib.catAttrs roleName projectDefinitions.${projectName};
        in
        if roles != [ ] then
          roles
        else
          throw "Project '${projectName}': role '${roleName}' is not defined in ${
            lib.concatMapStringsSep ", " toString projectPaths.${projectName}
          }";

      projects =
        let
          declared = mergeSettings (public.projects or { }) (private.projects or { });
          unknown = lib.filter (projectName: !(projectPaths ? ${projectName})) (lib.attrNames declared);
        in
        if unknown == [ ] then
          declared
        else
          throw "Constellation '${name}': unknown projects: ${lib.concatStringsSep ", " unknown}";

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
