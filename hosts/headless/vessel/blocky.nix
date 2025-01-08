let
  upstream = "https://one.one.one.one/dns-query";
in {
  services = {
    resolved.extraConfig = "DNSStubListener=no";
    blocky = {
      enable = true;
      settings = {
        ports.dns = 53;
        upstreams.groups.default = [upstream];
        bootstrapDns = {
          inherit upstream;
          ips = ["1.1.1.1" "1.0.0.1"];
        };
        blocking = {
          denylists.ads = ["https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"];
          clientGroupsBlock.default = ["ads"];
        };
        caching = {
          minTime = "5m";
          maxTime = "30m";
          prefetching = true;
        };
      };
    };
  };
}
