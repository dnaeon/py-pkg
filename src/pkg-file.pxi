
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
