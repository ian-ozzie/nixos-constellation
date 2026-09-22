projectArgs: {
  mysql = import ./mysql.nix projectArgs;
  php = import ./php.nix projectArgs;
  router = import ./router.nix projectArgs;
}
