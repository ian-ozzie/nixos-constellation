{ projectName, project, ... }:
{
  constellation,
  lib,
  pkgs,
  ...
}:
let
  address = memberName: constellation.manifests.${memberName}.network.addresses.lan;
  clients = map address (lib.toList project.roles.php);

  grants = pkgs.writeText "baikal-users.sql" (
    lib.concatMapStringsSep "\n" (client: ''
      CREATE USER IF NOT EXISTS '${projectName}'@'${client}' IDENTIFIED BY 'baikal-example-only';
      GRANT ALL PRIVILEGES ON `${projectName}`.* TO '${projectName}'@'${client}';
    '') clients
  );
in
{
  services.mysql.initialDatabases = [
    {
      name = projectName;
      schema = ./baikal.sql;
    }
  ];

  systemd.services.mysql.postStart = lib.mkAfter ''
    ${pkgs.mariadb}/bin/mariadb < ${grants}
  '';
}
