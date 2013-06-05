#!/usr/bin/env python

# File        : py-pkg-shlibs.py
# Author      : Marin Atanasov Nikolov <dnaeon@gmail.com>
# Description : Display the shared libraries required by a package

import pkg

db = pkg.PkgDb()

pkgs = db.query()
pkgs.load_shlibs_required()

for pkg in pkgs:
    print pkg.origin()
    print '-' * len(pkg.origin())

    if not len(pkg.shlibs_required()):
        print '\t<Does not require any shared libraries>\n'
        continue
    
    for shlib in pkg.shlibs_required():
        print '\t%s' % shlib

    print

db.close()
