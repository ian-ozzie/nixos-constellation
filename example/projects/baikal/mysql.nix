{ projectName, project, ... }:
{
  constellation,
  lib,
  pkgs,
  ...
}:
let
  address = member: constellation.manifests.${member}.network.addresses.lan;
  clients = map address (lib.toList project.roles.php);

  grants = pkgs.writeText "baikal-users.sql" (
    lib.concatMapStringsSep "\n" (client: ''
      CREATE USER IF NOT EXISTS 'baikal'@'${client}' IDENTIFIED BY 'baikal-example-only';
      GRANT ALL PRIVILEGES ON `${projectName}`.* TO 'baikal'@'${client}';
    '') clients
  );
in
{
  ozzie.lab.mysql.enable = true;

  services = {
    firewalld.zones.nixos-fw-default.rules = map (client: {
      "@family" = "ipv4";
      accept = "";
      source."@address" = client;

      port = {
        "@port" = "3306";
        "@protocol" = "tcp";
      };
    }) clients;

    mysql = {
      ensureDatabases = [ projectName ];
      settings.mysqld.bind-address = address project.roles.mysql;
    };
  };

  systemd.services.mysql.postStart = lib.mkAfter ''
    ${pkgs.mariadb}/bin/mariadb < ${grants}
  '';
}
