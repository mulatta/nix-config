{ config, ... }:
{
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Network settings with static IP

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall = {
    enable = true;
    allowedUDPPorts = [ 41641 ];
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPortRanges = [
      { from = 1024; to = 65535; }
    ];
  };

}
