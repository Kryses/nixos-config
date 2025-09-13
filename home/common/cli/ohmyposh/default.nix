{
  programs.oh-my-posh = let 
    omp-theme = ./omp-kryses.toml; 
  in 
  {
    enable = true;
    settings = builtins.fromTOML (builtins.unsafeDiscardStringContext (builtins.readFile "${omp-theme}"));
  };
}
