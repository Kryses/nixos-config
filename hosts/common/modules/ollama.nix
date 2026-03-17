{
  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;
    environmentVariables = {
      OLLAMA_HOST = "0.0.0.0"; # used to be necessary, but doesn't seem to anymore
    };
  };
}
