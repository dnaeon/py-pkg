
cdef class Pkg(object):  
    cdef c_pkg.pkg *_pkg                                                                                                 

    def __cinit__(self, pkg):                                                                                            
        self._pkg = <c_pkg.pkg *>pkg                                                                                     

    def __dealloc__(self):                                                                                               
        c_pkg.pkg_free(pkg=self._pkg)                                                                                    

    cpdef name(self):                                                                                                    
        cdef const char *name = NULL                                                                                     
        c_pkg.pkg_get(self._pkg, c_pkg.PKG_NAME, &name)                                                                  

        return name
