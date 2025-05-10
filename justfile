# default recipe to display help information
@default:
  just --list

   
# remote install nixos on host
bootstrap TARGET:
    nix run github:nix-community/nixos-anywhere -- --flake .#mulatta --target-host TARGET

# Back-up a new age key
key-backup KEYID:
    export-sec
    paperkey --secret-key "/tmp/{{KEYID}}_backup.gpg" --output "/tmp/{{KEYID}}_paper.txt"
    lpr "/tmp/{{KEYID}}_paper.txt"

export-sec KEYID:
    gpg --export {{KEYID}} > "/tmp/{{KEYID}}_backup.gpg"
    
export-pub KEYID:
    gpg --export {{KEYID}} > "/tmp/{{KEYID}}_pub.gpg"

key-recovery KEYID:
    paperkey --pubring  "/tmp/{{KEYID}}_pub.gpg"
