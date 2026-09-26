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
  clients =
    projectNetwork.addresses "backend" project.roles.router
    ++ projectNetwork.addresses "backend" (project.roles.monitor or [ ]);
in
{
  services = {
    baikal = {
      enable = true;
      virtualHost = hostName;
    };

    firewalld.zones.nixos-fw-default.rules = map (client: {
      "@family" = "ipv4";
      accept = "";
      source."@address" = client;

      port = {
        "@port" = "80";
        "@protocol" = "tcp";
      };
    }) clients;

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
