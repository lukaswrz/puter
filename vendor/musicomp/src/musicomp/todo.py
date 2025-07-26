from pathlib import Path
from os import PathLike
from enum import StrEnum
from dataclasses import dataclass
from typing import Self, override
from collections.abc import Generator
from .transcode import transcode as todo_transcode
from .clean import clean as todo_clean
from .replace import replace as todo_replace

SRC_SUFFIX = ".flac"
DST_SUFFIX = ".opus"


class TodoAct(StrEnum):
    TRANSCODE = "transcode"
    CLEAN = "clean"
    REPLACE = "replace"


@dataclass
class Todo:
    act: TodoAct
    src: str | PathLike[str]
    dst: str | PathLike[str]

    @classmethod
    def plan(
        cls: type[Self],
        src_dir: str | PathLike[str],
        dst_dir: str | PathLike[str],
        replace: bool = False,
        redo: bool = False,
    ) -> Generator[Self]:
        def list_files(dir: str | PathLike[str], suffix: str) -> list[Path]:
            files: list[Path] = []
            for f in Path(dir).rglob("*"):
                if f.is_file() and f.suffix == suffix:
                    files.append(f)
            return files

        src_files = list_files(src_dir, SRC_SUFFIX)
        dst_files = list_files(dst_dir, DST_SUFFIX)

        for f in src_files:
            e = dst_dir / (f.relative_to(src_dir).with_suffix(DST_SUFFIX))
            if redo or e not in dst_files:
                yield cls(TodoAct.TRANSCODE, f, e)
            if replace:
                yield cls(TodoAct.REPLACE, f, e)

        for f in dst_files:
            e = src_dir / (f.relative_to(dst_dir).with_suffix(SRC_SUFFIX))
            if e not in src_files:
                yield cls(TodoAct.CLEAN, f, e)

    def run(self) -> None:
        match self.act:
            case TodoAct.TRANSCODE:
                todo_transcode(self.src, self.dst)
            case TodoAct.CLEAN:
                todo_clean(self.dst)
            case TodoAct.REPLACE:
                todo_replace(self.src)

    @override
    def __str__(self) -> str:
        return f"{self.act} {self.src} -> {self.dst}"
