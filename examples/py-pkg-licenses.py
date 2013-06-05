#!/usr/bin/env python

# File        : py-pkg-licenses.py
# Author      : Marin Atanasov Nikolov <dnaeon@gmail.com>
# Description : Display package licenses

import pkg

db = pkg.PkgDb()

pkgs = db.query()
pkgs.load_licenses()

for pkg in pkgs:
    # skip packages that do not have any licenses
    if not pkg.licenses():
        continue
    
    print pkg.origin()
    print '-' * len(pkg.origin())

    for license in pkg.licenses():
        print '\t%s' % license

    print

db.close()
