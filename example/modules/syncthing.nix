{
  networking.firewall.allowedTCPPorts = [ 22000 ];

  services.syncthing = {
    configDir = "/persist/services/syncthing";

    settings.options = {
      crashReportingEnabled = false;
      globalAnnounceEnabled = false;
      natEnabled = false;
      relaysEnabled = false;
      stunKeepaliveStartS = 0;
      urAccepted = -1;
    };
  };

  systemd = {
    tmpfiles.rules = [
      "d /data 0755 root root"
      "d /data/files 0700 syncthing syncthing"
      "d /data/files/books 0700 syncthing syncthing"
      "f /data/files/books/.ignore 0700 syncthing syncthing"
      "d /data/files/documents 0700 syncthing syncthing"
      "f /data/files/documents/.ignore 0700 syncthing syncthing"

      "d /persist 0755 root root"
      "d /persist/services 0755 root root"
      "d /persist/services/syncthing 0755 syncthing syncthing"
    ];
  };
}
