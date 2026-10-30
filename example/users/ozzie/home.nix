{
  programs = {
    bash.enable = true;

    git = {
      enable = true;

      settings.user = {
        email = "ian@ozzie.id.au";
        name = "Ian Oswald";
      };
    };
  };
}
