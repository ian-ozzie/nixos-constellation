{ projectName, project, ... }:
{
  constellation,
  lib,
  ...
}:
let
  address = memberName: constellation.manifests.${memberName}.network.addresses.lan;
  clients = map address (lib.toList project.roles.php);
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
}
