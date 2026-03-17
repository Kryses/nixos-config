
{
  image = "docker.io/ljxha471758/llama-factory:latest";

  environment = {
    "TZ" = "America/New_York";
    "PORT" = "9000";
  };

  volumes = [
    "/home/kryses/.local/share/llamafactory/hf_cache:/root/.cache/huggingface"
    "/home/kryses/.local/share/llamafactory/ms_cache:/root/.cache/modelscope"
    "/home/kryses/.local/share/llamafactory/om_cache:/root/.cache/openmind" 
    "/home/kryses/.local/share/llamafactory/data:/app/data" 
    "/home/kryses/.local/share/llamafactory/output:/app/output" 
  ];

  ports = [
    "9000:8000" # Ensures we listen only on localhost
    "8860:7860"
  ];

  extraOptions = [
    "--hostname=llamafactory"
    "--name=llamafactory"
    "--network=host"
    "--add-host=host.containers.internal:host-gateway"
  ];
}
