{ project, ... }:
{
  constellation,
  lib,
  ...
}:
let
  backends = map (memberName: "${constellation.manifests.${memberName}.network.addresses.lan}:80") (
    lib.toList project.roles.php
  );
in
{
  ozzie.lab.caddy.enable = true;

  services.caddy = {
    enable = true;
    openFirewall = true;

    virtualHosts."${project.subdomain}.${project.domain}".extraConfig = ''
      tls internal

      handle {
        reverse_proxy ${lib.concatStringsSep " " backends} {
          lb_policy cookie
        }
      }
    '';
  };
}
