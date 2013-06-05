#!/usr/bin/env python

# File        : py-pkg-check.py
# Author      : Marin Atanasov Nikolov <dnaeon@gmail.com>
# Description : Check the database for missing package dependencies

from pkg import *

def check_deps(pkg, db):
    for dep in pkg.deps():
        if not db.pkg_is_installed(dep.origin()):
            print '%s has a missing dependency: %s' % (pkg.origin(), dep.origin())

def main():
    db = PkgDb()

    pkgs = db.query()
    pkgs.load_deps()

    for pkg in pkgs:
        check_deps(pkg, db)

    db.close()

if __name__ == '__main__':
    main()

