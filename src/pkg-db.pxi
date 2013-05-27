
cdef class PkgDb(object):
    cdef c_pkg.pkgdb *_db
    
    def __cinit__(self):
        if c_pkg.pkg_initialized() == True:
            raise PkgAlreadyInitialized, 'Already initialized'

        if c_pkg.pkg_init(NULL) != c_pkg.EPKG_OK:
            raise PkgNotInitialized, 'Cannot initialize libpkg'
        
        rc = c_pkg.pkgdb_open(&self._db, c_pkg.PKGDB_DEFAULT)

        if rc != c_pkg.EPKG_OK:
            raise IOError, 'Cannot open the package database'

    def __dealloc__(self):
        c_pkg.pkgdb_close(self._db)

