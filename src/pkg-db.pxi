
cdef class PkgDb(object):
    cdef c_pkg.pkgdb *_db
    cdef c_pkg.pkgdb_t _db_type
    
    def __cinit__(self, remotedb=False):
        if c_pkg.pkg_initialized() == True:
            raise PkgAlreadyInitialized, 'Already initialized'

        if c_pkg.pkg_init(NULL) != c_pkg.EPKG_OK:
            raise PkgNotInitialized, 'Cannot initialize libpkg'

        if remotedb == True:
            self._db_type = c_pkg.PKGDB_REMOTE
        else:
            self._db_type = c_pkg.PKGDB_DEFAULT
            
        rc = c_pkg.pkgdb_open(db=&self._db, db_type=self._db_type)

        if rc != c_pkg.EPKG_OK:
            raise IOError, 'Cannot open the package database'

    def __dealloc__(self):
        c_pkg.pkgdb_close(self._db)

