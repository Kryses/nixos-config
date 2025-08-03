{
  services.ollama = {
    enable = true;
    acceleration = "cuda";
    environmentVariables = {
      OLLAMA_HOST = "0.0.0.0"; # used to be necessary, but doesn't seem to anymore
    };
  };
}
