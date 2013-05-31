
cdef class PkgDep(object):
    cdef c_pkg.pkg_dep *_dep

    def __cinit__(self):
        self._dep = NULL

    cdef _init(self, c_pkg.pkg_dep *dep):
        self._dep = dep

    def __dealloc__(self):
        pass

    def __str__(self):
        return '%s-%s' % (self.name(), self.version())
        
    cpdef name(self):
        return c_pkg.pkg_dep_get(dep=self._dep, attr=c_pkg.PKG_DEP_NAME)

    cpdef origin(self):
        return c_pkg.pkg_dep_get(dep=self._dep, attr=c_pkg.PKG_DEP_ORIGIN)

    cpdef version(self):
        return c_pkg.pkg_dep_get(dep=self._dep, attr=c_pkg.PKG_DEP_VERSION)

cdef class PkgDepIter(object):
    cdef c_pkg.pkg *_pkg
    cdef c_pkg.pkg_dep *_dep

    def __cinit__(self):
        self._dep = NULL

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

    def __contains__(self, name):
        for d in self:
            if d.name() == name or d.origin() == name:
                return True

        return False

    def __next__(self):
        result = c_pkg.pkg_deps(pkg=self._pkg, dep=&self._dep)

        if result != c_pkg.EPKG_OK:
            raise StopIteration

        pkg_dep_obj = PkgDep()
        pkg_dep_obj._init(self._dep)

        return pkg_dep_obj

