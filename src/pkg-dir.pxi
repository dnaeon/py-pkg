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

cdef class PkgDir(object):
    """
    Package directory object.

    Provides methods for accessing package directory attributes.

    """
    cdef c_pkg.pkg_dir *_dir

    def __cinit__(self):
        """
        Initializes a new package directory object.

        """
        self._dir = NULL

    cdef _init(self, c_pkg.pkg_dir *dir):
        """
        Sets the C pointer of a package directory object.

        """
        self._dir = dir

    def __dealloc__(self):
        """
        Release any previously allocated resources.

        """
        pass

    cpdef path(self):
        """
        Retrieve the path of a package directory object.

        Returns:
            A string object representing the path to the package directory

        """
        return c_pkg.pkg_dir_get(dir=self._dir, attr=c_pkg.PKG_DIR_PATH)

    cpdef uname(self):
        """
        TODO: Document this method.

        """
        return c_pkg.pkg_dir_get(dir=self._dir, attr=c_pkg.PKG_DIR_UNAME)

    cpdef gname(self):
        """
        TODO: Document this method.

        """
        return c_pkg.pkg_dir_get(dir=self._dir, attr=c_pkg.PKG_DIR_GNAME)

cdef class PkgDirIter(object):
    """
    Package database iterator object.

    Provides methods for iterating over the directories provided by a package.

    """
    cdef c_pkg.pkg *_pkg
    cdef c_pkg.pkg_dir *_dir

    def __cinit__(self):
        """
        Initializes a new iterator object.

        """
        self._pkg = NULL
        self._dir = NULL

    cdef _init(self, c_pkg.pkg *pkg):
        """
        Sets the C pointer of the package we iterate it's directories over.

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
        Return the number of directories provided by a package.

        """
        cdef unsigned i = 0

        for d in self:
            i += 1

        return i

    def __next__(self):
        """
        Return the next package directory.

        Returns:
            PkgDir() object

        """
        result = c_pkg.pkg_dirs(pkg=self._pkg, dir=&self._dir)

        if result != c_pkg.EPKG_OK:
            raise StopIteration

        pkg_dirs_obj = PkgDir()
        pkg_dirs_obj._init(self._dir)

        return pkg_dirs_obj

    def __contains__(self, path):
        """
        Test if a package provides a directory.

        Returns:
            True if the package provides the directory, False otherwise.

        """
        for d in self:
            if d.path() == path:
                return True

        return False
