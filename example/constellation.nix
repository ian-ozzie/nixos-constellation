inputs:
let
  private = inputs.secrets.constellation inputs;
in
{
  inherit private;

  domain = "example.test";
  name = "example";

  membersDir = ./members;
  projectsDir = ./projects;
  usersDir = ./users;

  manifestDefaults = {
    allowUnfree = false;
    kind = "nspawn";
  };

  modules = [
    inputs.constellation.nixosModules.default
    inputs.ozzie-lab.nixosModules.default
    inputs.self.nixosModules.default

    {
      ozzie.constellation = {
        hosts = {
          enable = true;
          network = "lan";
        };

        syncthing = {
          enable = true;
          networks = [ "lan" ];
        };
      };
    }
  ];

  projects = {
    baikal = {
      domain = "example.test"; # Default to constellation.domain when absent
      subdomain = "baikal"; # Defaults to the source project name

      networks = {
        frontend = "lan";
        backend = "lan";
      };

      roles = {
        monitor = "monitor";
        mysql = "foo";
        router = "baz";

        php = [
          "bar"
          "private"
        ];
      };
    };

    baikal-dev = {
      domain = "local.test";
      project = "baikal";

      networks = {
        frontend = "lan";
        backend = "internal";
      };

      roles = {
        mysql = "dev";
        router = "dev";
        php = "dev";
      };
    };
  };

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

  users = [
    "deploy"
  ];
}
