# SSH Agent Forwarding configuration for NixOS
# Add this to your host configuration (e.g., hosts/mulatta/default.nix)
{
  # Enable SSH daemon with agent forwarding
  services.openssh = {
    enable = true;
    settings = {
      # Allow agent forwarding
      AllowAgentForwarding = true;

      # Security settings
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
      PubkeyAuthentication = true;
    };
  };

  # Optional: Configure SSH client for outbound connections
  programs.ssh = {
    # Enable SSH client system-wide
    startAgent = true;

    # Global SSH client configuration
    extraConfig = ''
      # Enable agent forwarding by default (use with caution)
      ForwardAgent yes

      # Prefer YubiKey authentication
      IdentitiesOnly yes

      # Add known YubiKey identities
      AddKeysToAgent yes
    '';
  };

  # User-specific SSH configuration
  users.users.seungwon = {
    openssh.authorizedKeys.keys = [
      # Your YubiKey public keys
      (builtins.readFile ../../home/seungwon/keys/ssh_id_ed25519_sk.pub)
      (builtins.readFile ../../home/seungwon/keys/ssh_backup_id_ed25519_sk.pub)
    ];
  };
}
