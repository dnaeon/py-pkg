
cdef class PkgRdepIter(PkgDepIter):

    def __next__(self):
        result = c_pkg.pkg_rdeps(self._pkg, &self._dep)

        if result != c_pkg.EPKG_OK:
            raise StopIteration

        pkg_dep_obj = PkgDep()
        pkg_dep_obj._init(self._dep)

        return pkg_dep_obj

