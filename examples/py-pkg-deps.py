#!/usr/bin/env python

# File            : py-pkg-deps.py
# Author          : Marin Atanasov Nikolov <dnaeon@gmail.com>
# Example purpose : Display package dependencies

import pkg

db = pkg.PkgDb()

pkgs = db.query()
pkgs.load_deps()

for pkg in pkgs:
    print pkg
    print '-' * len(pkg.name() + '-' + pkg.version())

    if not len(pkg.deps()):
        print '\t<Does not have dependencies>'
        continue

    for dep in pkg.deps():
        print '\t%s' % dep

db.close()
