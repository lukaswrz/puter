{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yadal";
  version = "0-unstable-2026-08-24";
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "tomkoid";
    repo = "yadal";
    rev = "9e4b8164ae2a8931423b1d7703f29dcffd94c108";
    hash = "sha256-8eAGrcOLcxdfq2eUO85+rZa9Qckhl5mvbNQx2now8a8=";
  };

  cargoHash = "sha256-XV5crj3ngXtWcsN4IFUoh3qER2iFAdXjiJjg2Z5ogbE=";

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Yet another TIDAL Hi-Res audio downloader for the CLI";
    homepage = "https://codeberg.org/tomkoid/yadal";
    license = lib.licenses.gpl3Only;
    mainProgram = "yadal";
  };
})
