{
  constellation,
  inputs,
  lib,
  manifest,
  memberName,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? home-manager) {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = {
        inherit
          constellation
          inputs
          manifest
          memberName
          ;
      };

      sharedModules = [
        {
          home.stateVersion = manifest.stateVersion;
        }
      ];
    };
  };
}
