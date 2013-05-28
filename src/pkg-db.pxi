
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

    cpdef close(self):
        c_pkg.pkgdb_close(self._db)
        
    cpdef query(self, pattern=None, match_regex=False):
        cdef c_pkg.pkgdb_it *_it = NULL
        cdef c_pkg.match_t _match = c_pkg.MATCH_EXACT

        # TODO: Implement the rest of the match_t types
        
        if match_regex:
            _match = c_pkg.MATCH_REGEX

        _it = c_pkg.pkgdb_query(db=self._db, pattern=pattern, match=_match)

        if _it == NULL:
            raise IOError, 'Cannot query the package database'

        return PkgDbIter(<object>_it)

cdef class PkgDbIter(object):
    cdef c_pkg.pkgdb_it *_it
    cdef unsigned _flags
    
    def __cinit__(self, it):
        self._it = <c_pkg.pkgdb_it *>it
        self._flags = c_pkg.PKG_LOAD_BASIC

    def __dealloc__(self):
        c_pkg.pkgdb_it_free(it=self._it)

    def __iter__(self):
        return self

    def __next__(self):
        cdef c_pkg.pkg *pkg = NULL
        result = c_pkg.pkgdb_it_next(it=self._it, pkg=&pkg, flags=self._flags)

        if result != c_pkg.EPKG_OK:
            c_pkg.pkgdb_it_reset(it=self._it)
            raise StopIteration

        return Pkg(<object>pkg)

    def __len__(self):
        cdef unsigned i = 0

        for p in self:
            i += 1

        return i
        
    def __contains__(self, name):
        for p in self:
            if p.name() == name or p.origin() == name:
                return True

        return False
    
