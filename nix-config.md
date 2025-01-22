# Nix Config

`/etc/nix/nix.conf`

 ```conf
#
# https://nixos.org/manual/nix/stable/#sec-conf-file
#

# Unix group containing the Nix build user accounts
experimental-features = nix-command flakes
build-users-group = nixbld 

# Disable sandbox
# sandbox = false



```
