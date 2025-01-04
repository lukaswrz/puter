from os import PathLike
from pathlib import Path


def replace(src: str | PathLike[str]) -> None:
    Path(src).unlink(missing_ok=True)
