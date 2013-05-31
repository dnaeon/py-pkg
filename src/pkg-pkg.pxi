
cdef class Pkg(object):  
    cdef c_pkg.pkg *_pkg
    cdef const char *_attr_str
    cdef bint _attr_bool
    cdef unsigned int _attr_int

    def __cinit__(self):                                                                                            
        self._attr_str = NULL
        self._attr_bool = False
        self._attr_int = 0

    cdef _init(self, c_pkg.pkg *pkg):
        self._pkg = pkg
        
    def __dealloc__(self):                                                                                               
        c_pkg.pkg_free(pkg=self._pkg)

    def __str__(self):
        return '%s-%s' % (self.name(), self.version())

    cdef pkg_get_attr_str(self, c_pkg.pkg_attr attr):
        c_pkg.pkg_get(self._pkg, attr, &self._attr_str)

        return self._attr_str

    cdef pkg_get_attr_bool(self, c_pkg.pkg_attr attr):
        c_pkg.pkg_get(self._pkg, attr, &self._attr_bool)

        return self._attr_bool

    cdef pkg_get_attr_int(self, c_pkg.pkg_attr attr):
        c_pkg.pkg_get(self._pkg, attr, &self._attr_int)

        return self._attr_int
        
    cpdef origin(self):
        return self.pkg_get_attr_str(c_pkg.PKG_ORIGIN)
        
    cpdef name(self):                                                                                                    
        return self.pkg_get_attr_str(c_pkg.PKG_NAME)

    cpdef version(self):
        return self.pkg_get_attr_str(c_pkg.PKG_VERSION)

    cpdef comment(self):
        return self.pkg_get_attr_str(c_pkg.PKG_COMMENT)

    cpdef desc(self):
        return self.pkg_get_attr_str(c_pkg.PKG_DESC)

    cpdef mtree(self):
        return self.pkg_get_attr_str(c_pkg.PKG_MTREE)

    cpdef message(self):
        return self.pkg_get_attr_str(c_pkg.PKG_MESSAGE)

    cpdef arch(self):
        return self.pkg_get_attr_str(c_pkg.PKG_ARCH)

    cpdef maintainer(self):
        return self.pkg_get_attr_str(c_pkg.PKG_MAINTAINER)

    cpdef www(self):
        return self.pkg_get_attr_str(c_pkg.PKG_WWW)

    cpdef prefix(self):
        return self.pkg_get_attr_str(c_pkg.PKG_PREFIX)

    cpdef infos(self):
        return self.pkg_get_attr_str(c_pkg.PKG_INFOS)

    cpdef repopath(self):
        return self.pkg_get_attr_str(c_pkg.PKG_REPOPATH)

    cpdef cksum(self):
        return self.pkg_get_attr_str(c_pkg.PKG_CKSUM)

    cpdef old_version(self):
        return self.pkg_get_attr_str(c_pkg.PKG_OLD_VERSION)

    cpdef reponame(self):
        return self.pkg_get_attr_str(c_pkg.PKG_REPONAME)

    cpdef repourl(self):
        return self.pkg_get_attr_str(c_pkg.PKG_REPOURL)

    cpdef digest(self):
        return self.pkg_get_attr_str(c_pkg.PKG_DIGEST)

    cpdef old_flatsize(self):
        return self.pkg_get_attr_int(c_pkg.PKG_OLD_FLATSIZE)

    cpdef size(self):
        return self.pkg_get_attr_int(c_pkg.PKG_PKGSIZE)

    cpdef license_logic(self):
        return self.pkg_get_attr_int(c_pkg.PKG_LICENSE_LOGIC)

    cpdef automatic(self):
        return self.pkg_get_attr_bool(c_pkg.PKG_AUTOMATIC)

    cpdef locked(self):
        return self.pkg_get_attr_bool(c_pkg.PKG_AUTOMATIC)

    cpdef rowid(self):
        return self.pkg_get_attr_int(c_pkg.PKG_ROWID)

    cpdef time(self):
        return self.pkg_get_attr_int(c_pkg.PKG_TIME)

    cpdef deps(self):
        deps_iter_obj = PkgDepIter()
        deps_iter_obj._init(self._pkg)

        return deps_iter_obj

    cpdef rdeps(self):
        rdeps_iter_obj = PkgRdepIter()
        rdeps_iter_obj._init(self._pkg)

        return rdeps_iter_obj

    cpdef files(self):
        files_iter_obj = PkgFileIter()
        files_iter_obj._init(self._pkg)

        return files_iter_obj
        
