#
# Copyright (c) 2013 Marin Atanasov Nikolov <dnaeon@gmail.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer
#    in this position and unchanged.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR(S) ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR(S) BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

cdef class PkgLicense(object):
    """
    Package license object

    Provides methods for access various package license attributes.

    """
    cdef c_pkg.pkg_license *_license

    def __cinit__(self):
        """
        Initiliaze a new package license object.

        """
        self._license = NULL

    cdef _init(self, c_pkg.pkg_license *license):
        """
        Set the C pointer of the package license object.

        """
        self._license = license

    def __dealloc__(self):
        """
        Release any previously allocated resources.

        """
        pass

    def __str__(self):
        """
        String representation of the package license.

        Returns:
            A string representation of the package license, e.g. 'BSD'

        """
        return '%s' % self.name()
        
    cpdef name(self):
        """
        Name of the package license.

        Returns:
            String object representing the license name

        """
        return c_pkg.pkg_license_name(license=self._license)

cdef class PkgLicenseIter(object):
    """
    Package license iterator object.

    Provides a mechanism for iterating over the licenses of a package object.

    """
    cdef c_pkg.pkg *_pkg
    cdef c_pkg.pkg_license *_license

    def __cinit__(self):
        """
        Initialize a new license iterator object.

        """
        self._license = NULL

    cdef _init(self, c_pkg.pkg *pkg):
        """
        Set the C pointer of the package object.

        """
        self._pkg = pkg

    def __dealloc__(self):
        """
        Release any previously allocated resources.

        """
        pass

    def __iter__(self):
        return self

    def __len__(self):
        """
        Return the number of licenses for a package.

        """
        cdef unsigned i = 0

        for d in self:
            i += 1

        return i

    def __contains__(self, name):
        """
        Test if a package is licensed under a specific license.

        Returns:
            True if the package is licensed under the license in question, False otherwise.

        """
        for l in self:
            if l.name() == name:
                return True

        return False

    def __next__(self):
        """
        Next license of a package.

        Return the next license from the package license iterator.

        """
        result = c_pkg.pkg_licenses(pkg=self._pkg, license=&self._license)

        if result != c_pkg.EPKG_OK:
            raise StopIteration

        pkg_license_obj = PkgLicense()
        pkg_license_obj._init(self._license)

        return pkg_license_obj
            
