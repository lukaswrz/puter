{
  proxyHosts = {
    headscale = {
      virtualHostName = "headscale.moontide.ink";
      host = "::1";
      port = 8000;
    };

    vaultwarden = {
      virtualHostName = "vault.moontide.ink";
      host = "::1";
      port = 8010;
    };

    forgejo = {
      virtualHostName = "hack.moontide.ink";
      host = "::1";
      port = 8020;
    };

    continuwuity = {
      virtualHostName = "matrix.moontide.ink";
      host = "::1";
      port = 8030;
    };

    searx = {
      virtualHostName = "find.moontide.ink";
      host = "::1";
      port = 8040;
    };
  };
}
