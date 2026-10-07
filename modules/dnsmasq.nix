{
  config,
  constellation,
  lib,
  ...
}:
let
  cfg = config.ozzie.constellation.dnsmasq;
  routedProjects = lib.filterAttrs (_: project: project.roles ? router) constellation.projects;

  records = lib.concatLists (
    lib.mapAttrsToList (
      projectName: project:
      map (address: {
        name = "${project.subdomain}.${project.domain}";
        value = address;
      }) (constellation.projectNetworks.${projectName}.addresses "frontend" project.roles.router)
    ) routedProjects
  );
in
{
  options.ozzie.constellation.dnsmasq = {
    enable = lib.mkEnableOption "write constellation projects to dnsmasq";
  };

  config = lib.mkIf cfg.enable {
    services.dnsmasq = {
      enable = true;
      settings.host-record = map (record: "${record.name},${record.value}") records;
    };
  };
}
