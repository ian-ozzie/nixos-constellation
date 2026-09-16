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
    ({ pkgs, ... }: {
      nix.settings.trusted-users = [ "@wheel" ];

      environment = {
        systemPackages = with pkgs; [
          cowsay
        ];
      };
    })
  ];
}
