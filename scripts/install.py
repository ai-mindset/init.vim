"""Install this Neovim configuration and its runtime files together."""

import argparse
from datetime import datetime
import os
from pathlib import Path
import shutil
import tempfile


FILES = (
    "init.vim",
    "lua/jac_hover.lua",
    "scripts/jac_hover_docs.py",
    "syntax/jac.vim",
)


def install(source, destination):
    for relative in FILES:
        if not (source / relative).is_file():
            raise FileNotFoundError(f"Missing repository file: {source / relative}")
    destination.mkdir(parents=True, exist_ok=True)
    backup = None
    changed = []
    for relative in FILES:
        origin, target = source / relative, destination / relative
        if target.is_file() and target.read_bytes() == origin.read_bytes():
            continue
        if target.is_dir():
            raise IsADirectoryError(f"Expected a file at {target}")
        if target.exists() or target.is_symlink():
            if backup is None:
                stamp = datetime.now().strftime("%Y%m%d-%H%M%S-")
                backup = Path(tempfile.mkdtemp(prefix=f"{destination.name}.backup-{stamp}",
                                               dir=destination.parent))
            saved = backup / relative
            saved.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(target, saved, follow_symlinks=False)
        target.parent.mkdir(parents=True, exist_ok=True)
        handle, temporary = tempfile.mkstemp(prefix=f".{target.name}.", dir=target.parent)
        os.close(handle)
        try:
            shutil.copy2(origin, temporary)
            os.replace(temporary, target)
        finally:
            Path(temporary).unlink(missing_ok=True)
        changed.append(relative)
    return changed, backup


def main():
    config_home = Path(os.environ.get("XDG_CONFIG_HOME", Path.home() / ".config"))
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--target", type=Path, default=config_home / "nvim",
                        help="Neovim configuration directory (default: %(default)s)")
    args = parser.parse_args()
    source = Path(__file__).resolve().parents[1]
    changed, backup = install(source, args.target.expanduser())
    print(f"Installed {len(changed)} changed file(s) in {args.target.expanduser()}")
    if backup:
        print(f"Previous files backed up in {backup}")
    print("Restart Neovim, then use :JacInfo and :JacHoverInfo.")


if __name__ == "__main__":
    main()
