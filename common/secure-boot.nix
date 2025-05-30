{
  self,
  attrName,
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (config.age) secrets;
in
{
  age.secrets.secure-boot.file = self + /secrets/secure-boot/${attrName}.tar.age;

  system.activationScripts.secureboot =
    let
      target = config.boot.lanzaboote.pkiBundle;
    in
    ''
      rm --recursive --force -- ${lib.escapeShellArg target}
      mkdir --parents -- ${lib.escapeShellArg target}
      ${lib.getExe pkgs.gnutar} --extract --file ${lib.escapeShellArg secrets.secure-boot.path} --directory ${lib.escapeShellArg target}
    '';
}
