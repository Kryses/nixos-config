{
  users.groups.arm = { gid = 1001; };

  users.users.arm = {
    isNormalUser = true;
    uid = 1001;
    group = "arm";
    home = "/home/arm";
    createHome = true;
    description = "Automatic Ripping Machine";
    extraGroups = [ "media" ];
  };

  users.groups.media = { };
  users.users.kryses.extraGroups = [ "media" ];

  virtualisation.oci-containers.containers = {
    arm-rippers = {
      image = "docker.io/automaticrippingmachine/automatic-ripping-machine:latest";

      # You said: service should always be running
      autoStart = true;

      environment = {
        ARM_UID = "1001";
        ARM_GID = "1001";
        TZ = "America/New_York";
      };

      volumes = [
        "/home/arm:/home/arm"
        "/home/arm/Music:/home/arm/Music"
        "/home/arm/logs:/home/arm/logs"
        "/home/arm/media:/home/arm/media"
        "/home/arm/config:/etc/arm/config"
      ];

      # With bridge networking, this works exactly as expected:
      ports = [ "8090:8080" ];

      extraOptions = [
        "--pull=newer"
        "--name=arm-rippers"
        "--hostname=arm-rippers"

        # Optical drive
        "--device=/dev/sr0:/dev/sr0"

        # Keep this for now since ARM often expects it for tray + sg/ioctl
        "--privileged"
      ];
    };
  };
}
