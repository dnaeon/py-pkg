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
    cdef c_pkg.pkg_file *_p_file

    def __cinit__(self):
        self._p_file = NULL

    cdef _init(self, c_pkg.pkg_file *p_file):
        self._p_file = p_file

    def __dealloc__(self):
        pass

    cpdef path(self):
        return c_pkg.pkg_file_get(p_file=self._p_file, attr=c_pkg.PKG_FILE_PATH)

    cpdef cksum(self):
        return c_pkg.pkg_file_get(p_file=self._p_file, attr=c_pkg.PKG_FILE_SUM)

    cpdef uname(self):
        return c_pkg.pkg_file_get(p_file=self._p_file, attr=c_pkg.PKG_FILE_UNAME)

    cpdef gname(self):
        return c_pkg.pkg_file_get(p_file=self._p_file, attr=c_pkg.PKG_FILE_GNAME)

cdef class PkgFileIter(object):
    cdef c_pkg.pkg *_pkg
    cdef c_pkg.pkg_file *_p_file

    def __cinit__(self):
        self._p_file = NULL

    cdef _init(self, c_pkg.pkg *pkg):
        self._pkg = pkg

    def __dealloc__(self):
        pass

    def __iter__(self):
        return self

    def __len__(self):
        cdef unsigned i = 0

        for d in self:
            i += 1

        return i

    def __next__(self):
        result = c_pkg.pkg_files(pkg=self._pkg, p_file=&self._p_file)

        if result != c_pkg.EPKG_OK:
            raise StopIteration

        pkg_files_obj = PkgFile()
        pkg_files_obj._init(self._p_file)

        return pkg_files_obj

    def __contains__(self, path):
        for f in self:
            if f.path() == path:
                return True

        return False
