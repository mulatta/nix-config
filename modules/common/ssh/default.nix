{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        extraOptions = {
          IgnoreUnknow = "UseKeyChain";
          useKeyChain = "yes";
          AddKeystoAgent = "yes";
        };
      };
      "my-server" = {
        hostname = "100.115.94.1";
        user = "mulatta";
        identityFile = ~/.ssh/eq12_ed25519;
        identitiesOnly = true;
        forwardAgent = false;
      };
      "github" = {
        hostname = "github.com";
        user = "git";
        identityFile = ~/.ssh/github_ed25519;
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
  # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIERkTnc18K6v80qc/LNfzEzQFSu1jbqA7PYuA+ch4Ui9 lsw1167@gmail.com";
}
