{
  lib,
  buildGoModule,
  wayland,
  libxkbcommon,
  libGL,
  pkg-config,
  xorg,
}:

buildGoModule {
  pname = "xenumenu";
  version = "unstable";

  src = lib.cleanSource ./.;

  vendorHash = "sha256-+Giw245jZzEIqmZdJjGOb348xmzuH0Y+6lhBE+Wi5B8=";

  ldflags = [
    "-s"
    "-w"
  ];

  tags = [
    "wayland"
  ];

  buildInputs = [
    wayland
    libxkbcommon
    libGL
    xorg.libX11
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "Simple GUI program launcher";
    license = lib.licenses.gpl3Only;
    mainProgram = "xenumenu";
  };
}
