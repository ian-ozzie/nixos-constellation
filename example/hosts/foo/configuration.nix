{
  services = {
    openssh.enable = true;

    syncthing.settings = {
      devices = {
        "Pixel" = {
          id = "SPVLEUO-ISUOTN5-G7PZDZ7-VZM67ZS-OIWMFJ5-DUHRS5F-3ZXV6IM-TQLHQQR";
        };
      };

      folders = {
        "04b95b8c-050c-4861-a22a-409b363cd8fc" = {
          devices = [
            "Pixel"
          ];
        };
      };
    };
  };
}
