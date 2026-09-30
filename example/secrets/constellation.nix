{ sops-nix, ... }:
{
  membersDir = ./members;
  projectsDir = ./projects;
  usersDir = ./users;

  modules = [
    sops-nix.nixosModules.sops
  ];

  services = {
    syncthing = {
      folders = {
        "fe9546ed-66f5-4805-88b9-65d241e34aee" = {
          enable = true;
          label = "Documents";
          ignorePatterns = [ "#include .ignore" ];
          path = "/data/files/documents";
          type = "sendreceive";

          devices = [
            "bar"
            "foo"
            "iPhone"
            "laptop"
            "private"
          ];
        };
      };
    };
  };
}
