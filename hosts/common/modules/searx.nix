{
    services.searx = {
    enable = true;
    settings = {
      search = {
        safe_search = 2;
        autocomplete_min = 2;
        autocomplete = "duckduckgo";
        ban_time_on_fail = 5;
        max_ban_time_on_fail = 120;
        formats = [
          "html"
          "json"
        ];
      };
      server = {
        port = 8888;
        bind_address = "0.0.0.0";
        secret_key = "secret key";
      };
    };
  };
}
