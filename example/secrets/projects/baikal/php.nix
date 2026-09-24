{ projectName, project, ... }:
{
  constellation,
  pkgs,
  ...
}:
let
  databaseHost = constellation.manifests.${project.roles.mysql}.network.addresses.lan;

  baikalConfig = pkgs.writeText "baikal.yaml" ''
    system:
      configured_version: 0.12.1
      timezone: Australia/Sydney
      card_enabled: true
      cal_enabled: true
      dav_auth_type: Digest
      admin_passwordhash: "edd69b232a1e96a427bfa7413a632ee7006d08d280936a5bc46c835a7008ffcb" # baikal-example-only
      failed_access_message: "user %u authentication failure for Baikal"
      auth_realm: BaikalDAV
      base_uri: ""
      invite_from: ""
    database:
      backend: mysql
      mysql_host: "${databaseHost}"
      mysql_dbname: ${projectName}
      mysql_username: ${projectName}
      mysql_password: baikal-example-only
      encryption_key: ce2257b94022683da6a770e28d2531cf
  '';
in
{
  systemd.tmpfiles.rules = [
    "C /var/lib/baikal/config/baikal.yaml 0600 baikal baikal - ${baikalConfig}"
  ];
}
