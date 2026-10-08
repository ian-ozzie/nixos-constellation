projectArgs:
let
  inherit (projectArgs) project projectName;
in
{
  common = { lib, ... }: {
    assertions = [
      {
        assertion = lib.isString (project.roles.mysql or null);
        message = "Project '${projectName}': role 'mysql' must name one member";
      }
    ];
  };

  monitor = import ./monitor.nix projectArgs;
  mysql = import ./mysql.nix projectArgs;
  php = import ./php.nix projectArgs;
  router = import ./router.nix projectArgs;
}
