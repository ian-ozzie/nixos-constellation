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
      discoverMembers = dir: lib.mapAttrs (_: path: import path inputs) (discoverDirs dir);
      hostNames = lib.unique (lib.attrNames publicMembers ++ lib.attrNames privateMembers);
      manifests = lib.mapAttrs memberManifest members;
      members = lib.genAttrs hostNames mergeMember;
      private = lib.recursiveUpdate privateDefaults (public.private or { });
      privateMembers = if private ? hostsDir then discoverMembers private.hostsDir else { };
      privateProjects = if private ? projectsDir then discoverDirs private.projectsDir else { };
      projectPaths = publicProjects // privateProjects;
      public = import (root + "/constellation.nix") inputs;
      publicMembers = if public ? hostsDir then discoverMembers public.hostsDir else { };
      publicProjects = if public ? projectsDir then discoverDirs public.projectsDir else { };
      roleMembers = role: lib.toList role;
      services = lib.recursiveUpdate (public.services or { }) (private.services or { });

      discoverDirs =
        dir:
        let
          entries = builtins.readDir dir;

          dirs = lib.filterAttrs (
            name: type: type == "directory" && builtins.pathExists (dir + "/${name}/default.nix")
          ) entries;
        in
        lib.mapAttrs (name: _: dir + "/${name}") dirs;

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

      projectModules = lib.genAttrs hostNames (
        memberName:
        lib.concatLists (
          lib.mapAttrsToList (
            projectName: project:
            lib.mapAttrsToList (roleName: _: projectRole projectName roleName) (
              lib.filterAttrs (_: role: lib.elem memberName (roleMembers role)) (project.roles or { })
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
          assignments = lib.flatten (
            lib.mapAttrsToList (
              roleName: role: map (memberName: { inherit memberName roleName; }) (roleMembers role)
            ) (project.roles or { })
          );

          errors = map (assignment: "${assignment.roleName} -> ${assignment.memberName}") (
            lib.filter (assignment: !(builtins.hasAttr assignment.memberName members)) assignments
          );
        in
        if errors == [ ] then
          project
        else
          throw "Project '${projectName}': unknown member assignments: ${lib.concatStringsSep ", " errors}"
      ) (lib.recursiveUpdate (public.projects or { }) (private.projects or { }));
    in
    {
      nixosConfigurations = lib.mapAttrs makeMember members;
    };
}
