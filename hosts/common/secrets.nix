{ inputs, config, ... }:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      "taskwarrior_sync_encryption_secret" = {
        owner = "kryses";
        group = "users";
        mode = "0400";
      };
    };

    templates."taskwarrior-taskrc" = {
      content = "sync.encryption_secret=${config.sops.placeholder."taskwarrior_sync_encryption_secret"}";
      owner = "kryses";
      group = "users";
      mode = "0400";
    };
  };
}
