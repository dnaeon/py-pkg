
cdef class PkgDir(object):
    cdef c_pkg.pkg_dir *_dir

    def __cinit__(self):
        self._dir = NULL

    cdef _init(self, c_pkg.pkg_dir *dir):
        self._dir = dir

    def __dealloc__(self):
        pass

    cpdef path(self):
        return c_pkg.pkg_dir_get(dir=self._dir, attr=c_pkg.PKG_DIR_PATH)

    cpdef uname(self):
        return c_pkg.pkg_dir_get(dir=self._dir, attr=c_pkg.PKG_DIR_UNAME)

    cpdef gname(self):
        return c_pkg.pkg_dir_get(dir=self._dir, attr=c_pkg.PKG_DIR_GNAME)

cdef class PkgDirIter(object):
    cdef c_pkg.pkg *_pkg
    cdef c_pkg.pkg_dir *_dir

    def __cinit__(self):
        self._pkg = NULL
        self._dir = NULL

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
        result = c_pkg.pkg_dirs(pkg=self._pkg, dir=&self._dir)

        if result != c_pkg.EPKG_OK:
            raise StopIteration

        pkg_dirs_obj = PkgDir()
        pkg_dirs_obj._init(self._dir)

        return pkg_dirs_obj

    def __contains__(self, path):
        for d in self:
            if d.path() == path:
                return True

        return False
