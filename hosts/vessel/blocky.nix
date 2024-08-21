let
  upstream = "https://one.one.one.one/dns-query";
in {
  services.blocky = {
    enable = true;
    settings = {
      port = 53;
      upstream.default = [upstream];
      bootstrapDns = {
        inherit upstream;
        ips = ["1.1.1.1" "1.0.0.1"];
      };
      blocking = {
        blackLists.ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
        clientGroupsBlock.default = ["ads"];
      };
      caching = {
        minTime = "5m";
        maxTime = "30m";
        prefetching = true;
      };
    };
  };
}
