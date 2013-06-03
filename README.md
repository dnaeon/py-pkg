## py-pkg -- Python wrappers for FreeBSD's libpkg library

The goal of this project is to provide Python wrappers for FreeBSD's libpkg library.

Python wrappers are written in Cython and compiled as a shared C library, which
can be imported into Python as any other Python module. 

By providing a Python interface to FreeBSD's libpkg library, one can interface
with the package library on a FreeBSD system.

This Python module provides interfaces for:

* Querying the local package database
* Querying the remote package databases
* Installation, deinstallation, autoremoving and upgrading of packages
* Retrieving package attributes -  name, version, origin, etc.
* And many others...

And all of this and more can be done from Python!

## Support the project

If you would like to support the project by making a donation, please check the link below. Thank you!

[![Support the Python wrappers for libpkg project](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=dnaeon%2epay%40gmail%2ecom&lc=US&item_name=Python%20wrappers%20for%20libpkg&no_note=0&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHostedGuest)

## Requirements

The Python wrappers are built against the latest libpkg version, as currently found in the master branch of pkgng, aka the development version of libpkg.

In order to be able to use the current Python wrappers you need to have the version of libpkg as found in the development/master branch of pkgng.

The reason why it was chosen to support only one branch (at least for now) is due to the huge differences in the libpkg API between the master and release-1.0 branch. Supporting these two branches is currently out of the possibility of the author to cope with.

But don't worry, soon enough the next stable branch of libpkg will support all these improvements from development, once the API settles down! :)

## Installation

In order to install the Python wrappers you would need these dependencies first installed:

* lang/cython

Once lang/cython is installed building and installing the Cython wrappers is straight-forward:

     $ python setup.py build
     $ sudo python setup.py install

## Examples

Here's one example of using the Python wrappers to get you warmed up :)

This is how you could list all installed packages on a FreeBSD system:

	#!/usr/bin/env python

	import pkg

	db = pkg.PkgDb()
	pkgs = db.query()

	for pkg in pkgs:
	    print pkg

	db.close()

For more examples, please refer to the examples page.
