from os import PathLike
from pathlib import Path


def clean(dst: str | PathLike[str]) -> None:
    Path(dst).unlink(missing_ok=True)
