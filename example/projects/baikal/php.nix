{ project, ... }:
{
  constellation,
  lib,
  pkgs,
  ...
}:
let
  hostName = "${project.subdomain}.${project.domain}";
  routerAddress = constellation.manifests.${project.roles.router}.network.addresses.lan;
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
      mysql_dbname: baikal
      mysql_username: baikal
      mysql_password: baikal-example-only
      encryption_key: ce2257b94022683da6a770e28d2531cf
  '';
in
{
  services = {
    baikal = {
      enable = true;
      virtualHost = hostName;
    };

    firewalld.zones.nixos-fw-default.rules = [
      {
        "@family" = "ipv4";
        accept = "";
        source."@address" = routerAddress;

        port = {
          "@port" = "80";
          "@protocol" = "tcp";
        };
      }
    ];

    nginx.virtualHosts.${hostName}.locations."~ ^(.+\\.php)(.*)$".extraConfig = lib.mkAfter ''
      fastcgi_param HTTPS on;
    '';
  };

  systemd.tmpfiles.rules = [
    "C /var/lib/baikal/config/baikal.yaml 0600 baikal baikal - ${baikalConfig}"
    "f /var/lib/baikal/specific/INSTALL_DISABLED 0600 baikal baikal -"
  ];
}
