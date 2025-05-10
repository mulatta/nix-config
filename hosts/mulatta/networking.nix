{config, ...}: {
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Network settings with static IP
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  networking = {
    hostName = "mulatta";
    useDHCP = false;

    # Static IP configuration
    interfaces.enp1s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.80.169.64";
          prefixLength = 24;
        }
      ];
    };

    # Gateway and DNS
    defaultGateway = "10.80.169.254";
    nameservers = [
      "117.16.191.6"
      "168.126.63.1"
    ];

    # Firewall configuration
    firewall = {
      enable = true;
      allowedUDPPorts = [41641];
      allowedUDPPortRanges = [
        {
          from = 1024;
          to = 65535;
        }
      ];
      trustedInterfaces = ["tailscale0"];
    };
  };
}
