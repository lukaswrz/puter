from pathlib import Path
from subprocess import run
from os import PathLike


class TranscodingError(Exception):
    pass


def transcode(src: str | PathLike[str], dst: str | PathLike[str]) -> None:
    dst = Path(dst)

    dst.parent.mkdir(parents=True, exist_ok=True)

    if dst.is_file():
        dst.unlink()

    opusenc: tuple[str, ...] = (
        "opusenc",
        "--quiet",
        "--bitrate",
        "96.000",
        "--music",
        "--vbr",
        "--comp",
        "10",
        "--",
        str(src),
        str(dst),
    )

    cp = run(opusenc)
    if cp.returncode != 0:
        raise TranscodingError(f"opusenc exited with code {cp.returncode}")
