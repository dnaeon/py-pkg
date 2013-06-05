#!/usr/bin/env python

# File        : py-pkg-category.py
# Author      : Marin Atanasov Nikolov <dnaeon@gmail.com>
# Description : Display package categories

import pkg

db = pkg.PkgDb()

pkgs = db.query()
pkgs.load_categories()

for pkg in pkgs:
    print pkg.origin()
    print '-' * len(pkg.origin())

    for cat in pkg.categories():
        print '\t%s' % cat

    print

db.close()
