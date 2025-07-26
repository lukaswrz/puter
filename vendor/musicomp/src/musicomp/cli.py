import sys
from multiprocessing import Pool, cpu_count
from argparse import ArgumentParser, ArgumentTypeError, Namespace
from pathlib import Path
from .todo import Todo

args = Namespace()


def task(todo: Todo) -> None:
    todo.run()
    if args.verbose:
        print("finished", todo, file=sys.stderr)


def main():
    def workers_type_func(value: object) -> int:
        try:
            value = int(value)  # pyright: ignore[reportArgumentType]
            if value <= 0:
                raise ArgumentTypeError(f"{value} is not a positive integer")
        except ValueError:
            raise ArgumentTypeError(f"{value} is not an integer")

        return value

    parser = ArgumentParser()

    _ = parser.add_argument(
        "-w",
        "--workers",
        default=cpu_count(),
        type=workers_type_func,
        help="amount of worker processes",
    )
    _ = parser.add_argument(
        "-i",
        "--interactive",
        action="store_true",
        help="prompt before running",
    )
    _ = parser.add_argument(
        "-k",
        "--keep",
        action="store_true",
        help="whether source files should be kept if both directories are the same",
    )
    _ = parser.add_argument(
        "-r",
        "--redo",
        action="store_true",
        help="whether everything should be re-encoded regardless of whether they have already been transcoded",
    )
    _ = parser.add_argument(
        "-v",
        "--verbose",
        action="count",
        default=0,
        help="verbose output",
    )

    _ = parser.add_argument(
        "music",
        nargs=1,
        type=Path,
        help="the source directory",
    )
    _ = parser.add_argument(
        "comp",
        nargs=1,
        type=Path,
        help="the destination directory for compressed files",
    )

    global args
    args = parser.parse_args(sys.argv[1:])

    assert isinstance(args.workers, int)  # pyright: ignore[reportAny]
    assert isinstance(args.interactive, bool)  # pyright: ignore[reportAny]
    assert isinstance(args.keep, bool)  # pyright: ignore[reportAny]
    assert isinstance(args.redo, bool)  # pyright: ignore[reportAny]
    assert isinstance(args.verbose, int)  # pyright: ignore[reportAny]
    assert isinstance(args.music, list)  # pyright: ignore[reportAny]
    assert len(args.music) == 1  # pyright: ignore[reportUnknownMemberType, reportUnknownArgumentType]
    assert isinstance(args.music[0], Path)  # pyright: ignore[reportUnknownMemberType]
    assert isinstance(args.comp, list)  # pyright: ignore[reportAny]
    assert len(args.comp) == 1  # pyright: ignore[reportUnknownMemberType, reportUnknownArgumentType]
    assert isinstance(args.comp[0], Path)  # pyright: ignore[reportUnknownMemberType]

    src_dir = args.music[0]  # pyright: ignore[reportUnknownMemberType]
    dst_dir = args.comp[0]  # pyright: ignore[reportUnknownMemberType]

    if args.verbose >= 1 or args.interactive:
        print("Planning...", file=sys.stderr)

    plan = list(
        Todo.plan(
            src_dir,
            dst_dir,
            replace=src_dir.samefile(dst_dir) and not args.keep,
            redo=args.redo,
        )
    )

    if len(plan) == 0:
        print("Nothing to do", file=sys.stderr)
        sys.exit(0)

    if args.verbose >= 1 or args.interactive:
        print("Plan:", file=sys.stderr)
        for todo in plan:
            print(todo, file=sys.stderr)

    if args.interactive:
        result = input("Do you want to continue? [Y/n] ")
        if result.lower() not in ("", "y", "yes"):
            sys.exit(1)

    with Pool(args.workers) as pool:
        _ = pool.map(task, plan)
