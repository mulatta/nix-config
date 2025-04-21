{
  imports = [
    ../shared/nixos
    ./hardware.nix
    ./disko-config.nix
  ];

  # ======= NETWORK SETTINGS FOR STATIC IP =======
  networking = {
    useDHCP = false;
    hostName = "mulatta";
    interfaces.enp1s0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.80.169.64";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = "10.80.169.254";
    nameservers = [
      "117.16.191.6"
      "168.126.63.1"
    ];
  };

}
