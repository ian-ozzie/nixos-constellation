{
  ozzie.lab = {
    syncthing.directOnly = true;
  };

  services.syncthing = {
    settings.options = {
      crashReportingEnabled = false;
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
    ];
  };
}
