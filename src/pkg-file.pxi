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

cdef class PkgFile(object):
    """
    Package file object.

    Provides methods for access attributes of files
    provided by a package.

    """
    cdef c_pkg.pkg_file *_file

    def __cinit__(self):
        """
        Initiliazes a new package file object.

        """
        self._file = NULL

    cdef _init(self, c_pkg.pkg_file *file):
        """
        Sets the C pointer of a package file object.

        """
        self._file = file

    def __dealloc__(self):
        """
        Release any previously allocated resources.

        Releases any previously allocated resources of
        the package file object.

        """
        pass

    cpdef path(self):
        """
        Retrieve the path of a file provided by a package.

        Returns:
            A string object representing the path of the package file.

        """
        return c_pkg.pkg_file_get(file=self._file, attr=c_pkg.PKG_FILE_PATH)

    cpdef cksum(self):
        """
        Retrieve the package file checksum.

        Retrieves and returns the package file checksum.

        Returns:
            A string object representing the checksum of the package file

        """
        return c_pkg.pkg_file_get(file=self._file, attr=c_pkg.PKG_FILE_SUM)

    cpdef uname(self):
        """
        TODO: Document this method

        """
        return c_pkg.pkg_file_get(file=self._file, attr=c_pkg.PKG_FILE_UNAME)

    cpdef gname(self):
        """
        TODO: Document this method

        """
        return c_pkg.pkg_file_get(file=self._file, attr=c_pkg.PKG_FILE_GNAME)

cdef class PkgFileIter(object):
    """
    Package file iterator object.

    Provides a mechanism for iterating over the files of a package.

    """
    cdef c_pkg.pkg *_pkg
    cdef c_pkg.pkg_file *_file

    def __cinit__(self):
        """
        Initialize the file iterator.

        """
        self._file = NULL

    cdef _init(self, c_pkg.pkg *pkg):
        """
        Sets the C ponter of the package object.

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
        Return the number of files provided by a package.

        Returns:
            Integer object representing the number of files provided by a package

        """
        cdef unsigned i = 0

        for d in self:
            i += 1

        return i

    def __next__(self):
        """
        Return the next package file.

        Returns:
            PkgFile() object

        """
        result = c_pkg.pkg_files(pkg=self._pkg, file=&self._file)

        if result != c_pkg.EPKG_OK:
            raise StopIteration

        pkg_files_obj = PkgFile()
        pkg_files_obj._init(self._file)

        return pkg_files_obj

    def __contains__(self, path):
        """
        Test if a file is provided by a package.

        Args:
            path (str): Path to the file

        Returns:
            True if the package provides the file, False otherwise

        """
        for f in self:
            if f.path() == path:
                return True

        return False
