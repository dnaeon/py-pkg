
cdef class PkgDb(object):
    cdef c_pkg.pkgdb *_db
    
    def __cinit__(self):
        c_pkg.pkg_init(NULL)
        
        rc = c_pkg.pkgdb_open(&self._db, c_pkg.PKGDB_DEFAULT)

        if rc != c_pkg.EPKG_OK:
            raise IOError, 'Cannot open the package database'

    def __dealloc__(self):
        c_pkg.pkgdb_close(self._db)

