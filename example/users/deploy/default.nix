{
  pkgs,
  ...
}:
{
  nix.settings.trusted-users = [ "deploy" ];
  services.openssh.settings.AllowUsers = [ "deploy" ];

  users.users.deploy = {
    extraGroups = [ "wheel" ];
    initialPassword = "fresh-SYSTEM-password-1234";
    isNormalUser = true;
    shell = with pkgs; bash;
    uid = 1234;
  };
}
