{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        extraOptions = {
          IgnoreUnknown = "UseKeyChain";
          UseKeychain = "yes";
          AddKeysToAgent = "yes";
        };
      };
      "my-server" = {
        hostname = "100.115.94.1";
        user = "mulatta";
        identityFile = "~/.ssh/eq12_ed25519";
        identitiesOnly = true;
        forwardAgent = false;
      };
      "github.com" = {
        identityFile = "~/.ssh/github_ed25519";
        identitiesOnly = true;
        forwardAgent = false;
        extraOptions = {
          ControlMaster = "auto";
          ControlPath = "~/.ssh/github.sock";
          ControlPersist = "5m";
        };
      };
    };
  };
  services.ssh-agent.enable = true;
}
