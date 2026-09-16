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
  services = { };

  core = [
    inputs.constellation.nixosModules.hosts

    {
      ozzie.constellation = {
        hosts = {
          enable = true;
          type = "vpn";
        };
      };
    }
  ];
}
