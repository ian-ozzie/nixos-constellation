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
  urlAddress = address: if lib.hasInfix ":" address then "[${address}]" else address;

  upstreams = map (address: "${urlAddress address}:8945") (
    projectNetwork.addresses "backend" project.roles.php
  );
in
{
  ozzie.lab.caddy = {
    enable = true;

    sites.${hostName} = {
      inherit upstreams;

      proxyConfig = "lb_policy cookie";

      listenAddresses = [
        (projectNetwork.address "frontend" memberName)
      ];
    };
  };
}
