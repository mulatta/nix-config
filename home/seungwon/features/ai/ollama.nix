{
  services.ollama = {
    enable = true;
    host = "127.0.0.1";
    # port = 11111;
    environmentVariables = {
      OLLAMA_KEEP_ALIVE = "10 m";
    };
  };
}
