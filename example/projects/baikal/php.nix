{ project, ... }:
{
  constellation,
  lib,
  ...
}:
let
  hostName = "${project.subdomain}.${project.domain}";
  routerAddress = constellation.manifests.${project.roles.router}.network.addresses.lan;
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
    "f /var/lib/baikal/specific/INSTALL_DISABLED 0600 baikal baikal -"
  ];
}
