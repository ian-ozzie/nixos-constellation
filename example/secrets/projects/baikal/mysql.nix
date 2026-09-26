{
  project,
  projectName,
  projectNetwork,
  ...
}:
{
  lib,
  pkgs,
  ...
}:
let
  clients = projectNetwork.addresses "backend" project.roles.php;

  grants = pkgs.writeText "baikal-users.sql" (
    lib.concatMapStringsSep "\n" (client: ''
      CREATE USER IF NOT EXISTS '${projectName}'@'${client}' IDENTIFIED BY 'baikal-example-only';
      GRANT ALL PRIVILEGES ON `${projectName}`.* TO '${projectName}'@'${client}';
    '') clients
  );
in
{
  systemd.services."project-${projectName}-mysql-seed" = {
    after = [ "mysql.service" ];
    requires = [ "mysql.service" ];
    wantedBy = [ "multi-user.target" ];

    script = ''
      if [ -z "$(${pkgs.mariadb}/bin/mariadb -N -e 'SHOW TABLES' '${projectName}')" ]; then
        ${pkgs.mariadb}/bin/mariadb '${projectName}' < ${./baikal.sql}
      fi

      ${pkgs.mariadb}/bin/mariadb < ${grants}
    '';

    serviceConfig = {
      RemainAfterExit = true;
      Type = "oneshot";
    };
  };
}
