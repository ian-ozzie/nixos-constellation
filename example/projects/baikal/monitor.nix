{
  project,
  projectName,
  projectNetwork,
  ...
}:
{ lib, ... }:
let
  hostName = "${project.subdomain}.${project.domain}";
  urlAddress = address: if lib.hasInfix ":" address then "[${address}]" else address;

  endpoint =
    name: settings:
    {
      inherit name;

      group = projectName;
      interval = "30s";
    }
    // settings;
in
{
  networking.hosts = lib.genAttrs (projectNetwork.addresses "frontend" project.roles.router) (_: [
    hostName
  ]);

  services.gatus = {
    enable = true;

    settings = {
      web.port = 80;

      endpoints =
        map (
          member:
          endpoint "mysql-${member}" {
            conditions = [ "[CONNECTED] == true" ];
            url = "tcp://${urlAddress (projectNetwork.address "backend" member)}:3306";
          }
        ) (lib.toList project.roles.mysql)
        ++ map (
          member:
          endpoint "php-${member}" {
            client.ignore-redirect = true;
            # An unauthenticated DAV request must reach PHP and request credentials
            conditions = [ "[STATUS] == 401" ];
            headers.Host = hostName;
            url = "http://${urlAddress (projectNetwork.address "backend" member)}/dav.php/";
          }
        ) (lib.toList project.roles.php)
        ++ [
          (endpoint "router" {
            conditions = [ "[STATUS] == 401" ];
            url = "https://${hostName}/dav.php/";

            client = {
              # The example router uses a local Caddy certificate authority
              insecure = true;
              ignore-redirect = true;
            };
          })
        ];

      storage = {
        path = "/var/lib/gatus/data.db";
        type = "sqlite";
      };
    };
  };

  systemd.services.gatus.serviceConfig = {
    AmbientCapabilities = lib.mkForce [
      "CAP_NET_RAW"
      "CAP_NET_BIND_SERVICE"
    ];

    CapabilityBoundingSet = lib.mkForce [
      "CAP_NET_RAW"
      "CAP_NET_BIND_SERVICE"
    ];
  };

  services.firewalld.zones.nixos-fw-default.ports = [
    {
      port = 80;
      protocol = "tcp";
    }
  ];
}
