
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
        
    cpdef query(self, pattern='', match_regex=False):
        cdef c_pkg.pkgdb_it *it = NULL
        cdef c_pkg.match_t match = c_pkg.MATCH_EXACT
        dbiter_obj = PkgDbIter()

        # TODO: Implement the rest of the match_t types
        
        if match_regex:
            match = c_pkg.MATCH_REGEX

        if not pattern:
            match = c_pkg.MATCH_ALL

        it = c_pkg.pkgdb_query(db=self._db, pattern=pattern, match=match)

        if it == NULL:
            raise IOError, 'Cannot query the package database'

        dbiter_obj._init(it)

        return dbiter_obj

cdef class PkgDbIter(object):
    cdef c_pkg.pkgdb_it *_it
    cdef unsigned _flags

    def __cinit__(self):
        self._flags = c_pkg.PKG_LOAD_BASIC

    cdef _init(self, c_pkg.pkgdb_it *it):
        self._it = it
        
    def __dealloc__(self):
        c_pkg.pkgdb_it_free(it=self._it)

    def __iter__(self):
        return self

    def __next__(self):
        cdef c_pkg.pkg *pkg = NULL
        pkg_obj = Pkg()
        
        result = c_pkg.pkgdb_it_next(it=self._it, pkg=&pkg, flags=self._flags)

        if result != c_pkg.EPKG_OK:
            c_pkg.pkgdb_it_reset(it=self._it)
            raise StopIteration

        pkg_obj._init(pkg)
            
        return pkg_obj

    def __len__(self):
        cdef unsigned i = 0

        c_pkg.pkgdb_it_reset(it=self._it)
        
        for p in self:
            i += 1

        return i
        
    def __contains__(self, name):
        for p in self:
            if p.name() == name or p.origin() == name:
                return True

        return False
    
    cpdef load_deps(self):
        self._flags |= c_pkg.PKG_LOAD_DEPS

    cpdef load_rdeps(self):
        self._flags |= c_pkg.PKG_LOAD_RDEPS

    cpdef load_files(self):
        self._flags |= c_pkg.PKG_LOAD_FILES

    cpdef load_scripts(self):
        self._flags |= c_pkg.PKG_LOAD_SCRIPTS

    cpdef load_options(self):
        self._flags |= c_pkg.PKG_LOAD_OPTIONS

    cpdef load_mtree(self):
        self._flags |= c_pkg.PKG_LOAD_MTREE

    cpdef load_dirs(self):
        self._flags |= c_pkg.PKG_LOAD_DIRS

    cpdef load_categories(self):
        self._flags |= c_pkg.PKG_LOAD_CATEGORIES

    cpdef load_licenses(self):
        self._flags |= c_pkg.PKG_LOAD_LICENSES

    cpdef load_users(self):
        self._flags |= c_pkg.PKG_LOAD_USERS

    cpdef load_groups(self):
        self._flags |= c_pkg.PKG_LOAD_GROUPS

    cpdef load_shlibs_required(self):
        self._flags |= c_pkg.PKG_LOAD_SHLIBS_REQUIRED

    cpdef load_shlibs_provided(self):
        self._flags |= c_pkg.PKG_LOAD_SHLIBS_PROVIDED

    cpdef load_annotations(self):
        self._flags |= c_pkg.PKG_LOAD_ANNOTATIONS
        
