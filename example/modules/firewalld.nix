{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.nftables.enable = true;
  services.firewalld.enable = true;

  # Backport https://github.com/NixOS/nixpkgs/pull/524004.
  systemd.services.firewalld = {
    serviceConfig.ExecReload = lib.mkForce [
      ""
      "${lib.getExe' pkgs.coreutils "kill"} -HUP $MAINPID"
    ];
    reloadTriggers = [
      config.environment.etc."firewalld/firewalld.conf".source
    ]
    ++ lib.mapAttrsToList (
      name: _: config.environment.etc."firewalld/zones/${name}.xml".source
    ) config.services.firewalld.zones
    ++ lib.mapAttrsToList (
      name: _: config.environment.etc."firewalld/services/${name}.xml".source
    ) config.services.firewalld.services;
  };
}
