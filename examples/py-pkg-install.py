#!/usr/bin/env python

# File        : py-pkg-install.py
# Author      : Marin Atanasov Nikolov <dnaeon@gmail.com>
# Description : Example installation of packages

import pkg

def main():
    for_install = []
    my_input = raw_input('Package to install: ')

    if not my_input:
        raise SystemExit, 'You need to supply a package for installation'
    else:
        for_install.append(my_input)

    db = pkg.PkgDb(remotedb=True)

    if db.pkg_is_installed(my_input):
        raise SystemExit, 'Package is already installed'

    try:
        jobs = db.install(pattern=for_install)
    except pkg.PkgAccessError:
        raise SystemExit, 'You do not have privileges to install packages'

    if not len(jobs):
        raise SystemExit, 'No packages matching the pattern'

    print '\nAbout to install the following packages:'

    for p in jobs:
        print '\t%s' % p
    
    print
    
    my_input = raw_input('Proceed with installation [y/n]: ')

    if my_input and my_input[0].lower() == 'y':
        jobs.apply()
    
    db.close()

if __name__ == '__main__':
    main()


