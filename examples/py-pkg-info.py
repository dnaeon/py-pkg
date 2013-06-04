#!/usr/bin/env python

# File            : py-pkg-info.py
# Author          : Marin Atanasov Nikolov <dnaeon@gmail.com>
# Example purpose : Display all packages installed on a FreeBSD system

import pkg

db = pkg.PkgDb()
pkgs = db.query()

for pkg in pkgs:
    print pkg

db.close()
