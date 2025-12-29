{
  users.groups.arm = {
    gid = 1001;
  };
   users.users.arm = {
    isNormalUser = true;
    uid = 1001;
    group = "arm";
    home = "/home/arm";
    createHome = true;

    # Optional but useful
    description = "Automatic Ripping Machine";
  };
  users.groups.media = { };

  users.users.arm.extraGroups = [ "media" ];
  users.users.kryses.extraGroups = [ "media" ];

  virtualisation.oci-containers.containers = {
    arm-rippers = {
      image = "docker.io/automaticrippingmachine/automatic-ripping-machine:latest";

      environment = {
        "ARM_UID" = "1001";
        "ARM_GID" = "1001";
      };

      volumes = [
        "/home/arm:/home/arm"
        "/home/arm/Music:/home/arm/Music"
        "/home/arm/logs:/home/arm/logs"
        "/home/arm/media:/home/arm/media"
        "/home/arm/config:/etc/arm/config"
      ];

      ports = [
        "8090:8080"
      ];

      extraOptions = [
        "--pull=newer"
        "--name=arm-rippers"
        "--hostname=arm-rippers"

        # Optical drive
        "--device=/dev/sr0:/dev/sr0"
        "--device=/dev/sr1:/dev/sr1"

        # Required for ARM to control the drive
        "--privileged"

        # "--restart=always"
      ];
    };
  };
}

