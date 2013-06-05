#!/usr/bin/env python

# File        : py-pkg-deps.py
# Author      : Marin Atanasov Nikolov <dnaeon@gmail.com>
# Description : Display package dependencies

import pkg

db = pkg.PkgDb()

pkgs = db.query()
pkgs.load_deps()

for pkg in pkgs:
    print pkg.origin()
    print '-' * len(pkg.origin())

    if not len(pkg.deps()):
        print '\t<Does not have dependencies>\n'
        continue

    for dep in pkg.deps():
        print '\t%s' % dep

    print

db.close()
