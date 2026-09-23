{ project, ... }:
{
  constellation,
  lib,
  ...
}:
let
  hostName = "${project.subdomain}.${project.domain}";

  backends = map (memberName: "${constellation.manifests.${memberName}.network.addresses.lan}:80") (
    lib.toList project.roles.php
  );
in
{
  ozzie.lab.caddy.enable = true;

  services.caddy = {
    enable = true;
    openFirewall = true;

    virtualHosts.${hostName}.extraConfig = ''
      tls internal

      handle {
        reverse_proxy ${lib.concatStringsSep " " backends} {
          lb_policy cookie
        }
      }
    '';
  };
}
