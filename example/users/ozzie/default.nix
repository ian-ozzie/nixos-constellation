{
  lib,
  options,
  pkgs,
  ...
}:
{
  config = {
    users.users.ozzie = {
      extraGroups = [ "wheel" ];
      initialPassword = "fresh-SYSTEM-password-1789";
      isNormalUser = true;
      shell = with pkgs; bash;
      uid = 1789;
    };
  }
  // lib.optionalAttrs (options ? home-manager) {
    home-manager.users.ozzie = ./home.nix;
  };
}
