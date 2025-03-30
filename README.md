# :snowflake: puter

This is my cobbled together NixOS configuration. There are many like it, but this one is mine. Copy at your own risk.

## TODO

- [ ] lanzaboote
- [ ] monitoring (prometheus)
- [ ] logging (loki)
- [ ] kiosk
- [ ] tailscale and headscale
- [ ] game rom sync insomniac
- [ ] insomniac backups
- [ ] nginx websites

## port allocation

* 80X0: public HTTP services that are proxied through nginx
* 40X0: private HTTP services that are accessible via tailscale
* 20XX: Administrative stuff, like prometheus etc.

* 8000: vaultwarden
* 8010: headscale

* 4000: syncthing
