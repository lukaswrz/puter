{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  nix-update-script,

  aws-lc,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "yadal";
  version = "0.4.0";
  __structuredAttrs = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "tomkoid";
    repo = "yadal";
    tag = finalAttrs.version;
    hash = "sha256-MOp1qlg/rittAcD/0JMvE1o/U+J6o66JRR8uVbdpw5Y=";
  };

  cargoHash = "sha256-J5huE4z8W9C2tVeir8VB7YmOROmr0umqZkbZSOo1iJs=";

  buildInputs = [
    aws-lc
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Yet another TIDAL Hi-Res audio downloader for the CLI";
    homepage = "https://codeberg.org/tomkoid/yadal";
    changelog = "https://codeberg.org/tomkoid/yadal/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "yadal";
  };
})
