#!/usr/bin/env python

# File        : py-pkg-options.py
# Author      : Marin Atanasov Nikolov <dnaeon@gmail.com>
# Description : Display package options

import pkg

db = pkg.PkgDb()

pkgs = db.query()
pkgs.load_options()

for pkg in pkgs:
    print pkg.origin()
    print '-' * len(pkg.origin())

    if not len(pkg.options()):
        print '\t<Package does not have options>'
    
    for option in pkg.options():
        print '\t%s' % option

    print

db.close()
