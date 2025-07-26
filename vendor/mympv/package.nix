{
  mpv,
  symlinkJoin,
  makeWrapper,
}:
symlinkJoin {
  inherit (mpv)
    name
    meta
    passthru
    ;

  paths = [ mpv ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/${mpv.meta.mainProgram} \
      --add-flag --config-dir=${./config}
  '';
}
