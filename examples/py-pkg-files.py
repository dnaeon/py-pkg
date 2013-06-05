#!/usr/bin/env python

# File        : py-pkg-files.py
# Author      : Marin Atanasov Nikolov <dnaeon@gmail.com>
# Description : Display package files

import pkg

db = pkg.PkgDb()

pkgs = db.query()
pkgs.load_files()

for pkg in pkgs:
    print pkg.origin()
    print '-' * len(pkg.origin())

    for f in pkg.files():
        print '\t%s' % f

    print

db.close()
