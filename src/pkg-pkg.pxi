
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

    

