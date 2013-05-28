
cdef class Pkg(object):  
    cdef c_pkg.pkg *_pkg
    cdef const char *_attr_val

    def __cinit__(self, pkg):                                                                                            
        self._pkg = <c_pkg.pkg *>pkg                                                                                     

    def __dealloc__(self):                                                                                               
        c_pkg.pkg_free(pkg=self._pkg)                                                                                    

    cdef pkg_get_attr(self, c_pkg.pkg_attr attr):
        c_pkg.pkg_get(self._pkg, attr, &self._attr_val)

        return self._attr_val
        
    cpdef origin(self):
        return self.pkg_get_attr(c_pkg.PKG_ORIGIN)
        
    cpdef name(self):                                                                                                    
        return self.pkg_get_attr(c_pkg.PKG_NAME)

    cpdef version(self):
        return self.pkg_get_attr(c_pkg.PKG_VERSION)

    cpdef comment(self):
        return self.pkg_get_attr(c_pkg.PKG_COMMENT)

    cpdef desc(self):
        return self.pkg_get_attr(c_pkg.PKG_DESC)

    cpdef mtree(self):
        return self.pkg_get_attr(c_pkg.PKG_MTREE)

    cpdef message(self):
        return self.pkg_get_attr(c_pkg.PKG_MESSAGE)

    cpdef arch(self):
        return self.pkg_get_attr(c_pkg.PKG_ARCH)

    cpdef maintainer(self):
        return self.pkg_get_attr(c_pkg.PKG_MAINTAINER)

    cpdef www(self):
        return self.pkg_get_attr(c_pkg.PKG_WWW)

    cpdef prefix(self):
        return self.pkg_get_attr(c_pkg.PKG_PREFIX)

    cpdef infos(self):
        return self.pkg_get_attr(c_pkg.PKG_INFOS)

    cpdef repopath(self):
        return self.pkg_get_attr(c_pkg.PKG_REPOPATH)

    cpdef cksum(self):
        return self.pkg_get_attr(c_pkg.PKG_CKSUM)

    cpdef old_version(self):
        return self.pkg_get_attr(c_pkg.PKG_OLD_VERSION)

    cpdef reponame(self):
        return self.pkg_get_attr(c_pkg.PKG_REPONAME)

    cpdef repourl(self):
        return self.pkg_get_attr(c_pkg.PKG_REPOURL)

    cpdef digest(self):
        return self.pkg_get_attr(c_pkg.PKG_DIGEST)

    

