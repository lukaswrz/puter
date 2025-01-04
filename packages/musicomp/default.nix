{
  lib,
  python3Packages,
  opusTools,
}:
python3Packages.buildPythonApplication {
  pname = "musicomp";
  version = "0.1.0";

  src = ./.;

  pyproject = true;

  doCheck = false;

  build-system = [python3Packages.hatchling];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [opusTools])
  ];

  meta.mainProgram = "musicomp";
}
