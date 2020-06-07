#!/usr/bin/env python3
import os
import shutil
import sys

if len(sys.argv) != 3:
    print(f'Usage: {sys.argv[0]} <dotfiles> <homedir>')
    sys.exit(1)

dotfiles_path, homedir = sys.argv[-2:]

BLACKLIST=[
    '.git',
    '.gitignore',
    'LICENSE.txt',
    'README.md',
]

for path, dirs, filenames in os.walk(dotfiles_path):
    if os.path.basename(path) in BLACKLIST:
        dirs.clear()
        filenames.clear()
    for filename in sorted(filenames + dirs):
        dirs.clear()
        filenames.clear()
        if filename not in BLACKLIST:
            full_path = os.path.abspath(os.path.join(path, filename))
            relpath = os.path.relpath(full_path, dotfiles_path)
            dest_path = os.path.join(homedir, relpath)
            source_path = os.path.relpath(full_path, homedir)
            if os.path.exists(dest_path):
                if os.path.islink(dest_path):
                    continue
                else:
                    os.unlink(dest_path)
            os.symlink(source_path, dest_path)
