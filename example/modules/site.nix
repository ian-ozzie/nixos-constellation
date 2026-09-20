{ pkgs, ... }:
{
  networking.dhcpcd.enable = false;

  environment = {
    enableAllTerminfo = true;

    systemPackages = with pkgs; [
      kitty.terminfo

      curl
      inetutils
      jq
      lsd
      lshw
      lsof
      man
      openssl
      ripgrep
      strace
      tcpdump
      wget
    ];
  };
}
