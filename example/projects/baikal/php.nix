{
  project,
  projectNetwork,
  ...
}:
{
  lib,
  memberName,
  ...
}:
let
  hostName = "${project.subdomain}.${project.domain}";
  routers = projectNetwork.addresses "backend" project.roles.router;
in
{
  services = {
    baikal = {
      enable = true;
      virtualHost = hostName;
    };

    firewalld.zones.nixos-fw-default.rules = map (router: {
      "@family" = "ipv4";
      accept = "";
      source."@address" = router;

      port = {
        "@port" = "80";
        "@protocol" = "tcp";
      };
    }) routers;

    nginx.virtualHosts.${hostName} = {
      listen = [
        {
          addr = projectNetwork.address "backend" memberName;
          port = 80;
        }
      ];

      locations."~ ^(.+\\.php)(.*)$".extraConfig = lib.mkAfter ''
        fastcgi_param HTTPS on;
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "f /var/lib/baikal/specific/INSTALL_DISABLED 0600 baikal baikal -"
  ];
}
