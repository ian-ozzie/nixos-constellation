{ sops-nix, ... }:
{
  core = [ sops-nix.nixosModules.sops ];
  hostsDir = ./hosts;
  usersDir = ./users;

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
