#!/usr/bin/env python

# File        : py-pkg-update.py
# Author      : Marin Atanasov Nikolov <dnaeon@gmail.com>
# Description : Update remote package repositories

import pkg

db = pkg.PkgDb()
db.update(force=True)
db.close()
