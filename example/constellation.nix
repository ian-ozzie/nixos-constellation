inputs:
let
  private = inputs.secrets.constellation inputs;
in
{
  inherit private;

  domain = "example.test";
  hostsDir = ./hosts;
  name = "example";
  network = { };

  core = [
    inputs.constellation.nixosModules.default
    inputs.ozzie-lab.nixosModules.default
    inputs.self.nixosModules.default

    {
      ozzie.constellation = {
        hosts = {
          enable = true;
          type = "lan";
        };

        syncthing = {
          enable = true;
          networks = [ "lan" ];
        };
      };
    }
  ];

  services = {
    syncthing = {
      devices = {
        "iPhone" = {
          id = "E3W5VFW-3ABWPKI-MONGVOH-OFHA6IT-OWDY25V-UFLYC6J-P2IZU3Z-D2YPEQF";
        };
      };

      folders = {
        "04b95b8c-050c-4861-a22a-409b363cd8fc" = {
          enable = true;
          label = "Books";
          ignorePatterns = [ "#include .ignore" ];
          path = "/data/files/books";
          type = "sendreceive";

          devices = [
            "bar"
            "foo"
            "iPhone"
            "laptop"
          ];
        };
      };
    };
  };
}
