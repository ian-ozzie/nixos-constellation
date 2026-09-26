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

  backends = map (address: "${address}:80") (projectNetwork.addresses "backend" project.roles.php);
in
{
  ozzie.lab.caddy.enable = true;

  services.caddy = {
    enable = true;
    openFirewall = true;

    virtualHosts.${hostName} = {
      extraConfig = ''
        tls internal

        handle {
          reverse_proxy ${lib.concatStringsSep " " backends} {
            lb_policy cookie
          }
        }
      '';

      listenAddresses = [
        (projectNetwork.address "frontend" memberName)
      ];
    };
  };
}
