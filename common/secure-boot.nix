{self, attrName, config, lib, pkgs, ...}: let
  inherit (config.age) secrets;
in{
  age.secrets.secure-boot.file = self + /secrets/secure-boot/${attrName}.tar.age;

  system.activationScripts.secureboot = let
    target = config.boot.lanzaboote.pkiBundle;
  in ''
    mkdir --parents ${target}
    ${lib.getExe pkgs.gnutar} --extract --file ${secrets.secure-boot.path} --directory ${target}
  '';
}
