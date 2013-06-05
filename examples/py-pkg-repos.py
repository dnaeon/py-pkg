#!/usr/bin/env python

# File        : py-pkg-repos.py
# Author      : Marin Atanasov Nikolov <dnaeon@gmail.com>
# Description : Display package repositories

import pkg

db = pkg.PkgDb()

for repo in db.repositories():
    print repo

db.close()
