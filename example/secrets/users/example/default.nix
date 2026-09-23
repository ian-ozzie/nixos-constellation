{
  pkgs,
  ...
}:
{
  services.openssh.settings.AllowUsers = [ "example" ];

  users.users.example = {
    extraGroups = [ "wheel" ];
    initialPassword = "fresh-SYSTEM-password-1235";
    isNormalUser = true;
    shell = with pkgs; bash;
    uid = 1235;
  };
}
