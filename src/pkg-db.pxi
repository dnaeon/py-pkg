#
# Copyright (c) 2013 Marin Atanasov Nikolov <dnaeon@gmail.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer
#    in this position and unchanged.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR(S) ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR(S) BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
# NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
# THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

cdef class PkgDb(object):
    """
    Package database

    """
    cdef c_pkg.pkgdb *_db
    cdef c_pkg.pkgdb_t _db_type
    cdef c_pkg.pkg_jobs *_jobs
    
    def __cinit__(self, remotedb=False):
        """
        Create a database object.

        Kwargs:
            remotedb (bool): Database mode

        Returns:
            None
        
        Raises:
            IOError, PkgAlreadyInitialized, PkgNotInitialized

        """
        self._jobs = NULL
        
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
        """
        Deallocate the package database object.

        Close the package database and release any allocated resources.

        A call to the close() method must be made in order to
        properly release any allocated resources.
        
        Returns:
            None

        """
        pass
        
    cpdef close(self):
        """
        Close the package database.

        Close the database and release any allocated resources.

        Returns:
            None

        """
        c_pkg.pkg_jobs_free(jobs=self._jobs)
        c_pkg.pkgdb_close(self._db)
        
    cpdef query(self, pattern='', match_regex=False):
        """
        Query the local package database.

        Queries the local package database and returns a package iterator.

        Kwargs:
            pattern     (str)  : Pattern to query for
            match_regex (bool) : Treat 'pattern' as a regular expression

        Returns:
            PkgDbIter() object that is ready for iteration over the query results

        Raises:
            IOerror

        """
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

    cpdef install(self, pattern=None, match_regex=False):
        """
        Query the remote database for 'pattern' and return a jobs object.

        Queries the remote database for 'pattern' and creates a jobs object,
        which can be used to install the packages matching the 'pattern'.

        Kwargs:
            pattern     (list): Pattern to query the remote database for
            match_regex (bool): If True treat 'pattern' as a regular expression
        
        Returns:
            PkgJobs() object

        Raises:
            MemoryError, PkgJobsAddError, PkgJobsSolveError, PkgAccessError

        """
        cdef int rc = c_pkg.EPKG_OK
        cdef c_pkg.pkg_jobs *jobs = NULL
        cdef c_pkg.match_t match = c_pkg.MATCH_EXACT
        cdef unsigned flags        = (c_pkg.PKG_FLAG_NONE |
                                      c_pkg.PKG_FLAG_PKG_VERSION_TEST)
        cdef unsigned mode_access  = (c_pkg.PKGDB_MODE_READ  | 
                                      c_pkg.PKGDB_MODE_WRITE |
                                      c_pkg.PKGDB_MODE_CREATE)
        cdef unsigned db_access    = (c_pkg.PKGDB_DB_LOCAL |
                                      c_pkg.PKGDB_DB_REPO)
        jobs_obj = PkgJobs()

        # check if we have enough permissions to install packages
        rc = c_pkg.pkgdb_access(mode=mode_access, database=db_access)

        if rc != c_pkg.EPKG_OK:
            raise PkgAccessError, 'Insufficient permissions to install packages'
        
        # re-open the database in remote mode if needed
        rc = c_pkg.pkgdb_open(db=&self._db, db_type=c_pkg.PKGDB_REMOTE)

        if rc != c_pkg.EPKG_OK:
            raise IOError, 'Cannot open the database in remote mode'

        if not isinstance(pattern, (list, tuple)):
            raise TypeError, 'Pattern should of type list or tuple'

        # convert 'pattern' to a char *array[]
        cdef unsigned i
        cdef unsigned num_pkgs = len(pattern)
        cdef char **pkgs = []

        for i in xrange(num_pkgs):
            pkgs[i] = pattern[i]
        
        # TODO: Implement the rest of the match_t types
        if match_regex:
            match = c_pkg.MATCH_REGEX

        # TODO: Implement setting the rest of the pkg_flags types
        
        rc = c_pkg.pkg_jobs_new(jobs=&jobs, type=c_pkg.PKG_JOBS_INSTALL, db=self._db)

        if rc != c_pkg.EPKG_OK:
            raise MemoryError, 'Cannot create a jobs object'

        c_pkg.pkg_jobs_set_flags(jobs=jobs, flags=flags)

        rc = c_pkg.pkg_jobs_add(jobs=jobs, match=match, argv=pkgs, argc=num_pkgs)

        if rc != c_pkg.EPKG_OK:
            raise PkgJobsAddError, 'Cannot add package jobs'

        rc = c_pkg.pkg_jobs_solve(jobs=jobs)

        if rc != c_pkg.EPKG_OK:
            raise PkgJobsSolveError, 'Cannot solve package jobs'
        
        jobs_obj._init(jobs)
        self._jobs = jobs

        return jobs_obj

    cpdef delete(self, pattern=None, match_regex=False):
        """
        Query the local database for 'pattern' and return a jobs object.
        
        Queries the local database for 'pattern' and creates a jobs object,
        which can be used to deinstall the packages matching the 'pattern'.
        
        Kwargs:
            pattern     (list): Pattern to query the local database for
            match_regex (bool): If True treat 'pattern' as a regular expression
        
        Returns:
            PkgJobs() object
        
        Raises:
            MemoryError, PkgJobsAddError, PkgJobsSolveError, PkgAccessError
        
        """
        cdef int rc = c_pkg.EPKG_OK
        cdef c_pkg.pkg_jobs *jobs = NULL
        cdef c_pkg.match_t match = c_pkg.MATCH_EXACT
        cdef unsigned flags        = c_pkg.PKG_FLAG_NONE
        cdef unsigned mode_access  = c_pkg.PKGDB_MODE_READ | c_pkg.PKGDB_MODE_WRITE
        cdef unsigned db_access    = c_pkg.PKGDB_DB_LOCAL
        jobs_obj = PkgJobs()

        # check if we have enough permissions to deinstall packages
        rc = c_pkg.pkgdb_access(mode=mode_access, database=db_access)
        
        if rc != c_pkg.EPKG_OK:
            raise PkgAccessError, 'Insufficient permissions to deinstall packages'
            
        if not isinstance(pattern, (list, tuple)):
            raise TypeError, 'Pattern should of type list or tuple'
            
        # convert 'pattern' to a char *array[]
        cdef unsigned i
        cdef unsigned num_pkgs = len(pattern)
        cdef char **pkgs = []
        
        for i in xrange(num_pkgs):
            pkgs[i] = pattern[i]

        # TODO: Implement the rest of the match_t types
        if match_regex:
            match = c_pkg.MATCH_REGEX

        # TODO: Implement setting the rest of the pkg_flags types
        
        rc = c_pkg.pkg_jobs_new(jobs=&jobs, type=c_pkg.PKG_JOBS_DEINSTALL, db=self._db)
        
        if rc != c_pkg.EPKG_OK:
            raise MemoryError, 'Cannot create a jobs object'
            
        c_pkg.pkg_jobs_set_flags(jobs=jobs, flags=flags)
    
        rc = c_pkg.pkg_jobs_add(jobs=jobs, match=match, argv=pkgs, argc=num_pkgs)

        if rc != c_pkg.EPKG_OK:
            raise PkgJobsAddError, 'Cannot add package jobs'
            
        rc = c_pkg.pkg_jobs_solve(jobs=jobs)
        
        if rc != c_pkg.EPKG_OK:
            raise PkgJobsSolveError, 'Cannot solve package jobs'
        
        jobs_obj._init(jobs)
        self._jobs = jobs

        return jobs_obj

    cpdef autoremove(self):
        """
        Return a PkgJobs() object with packages ready to be autoremoved.
        
        Queries the local database for packages ready to be autoremoved.
        
        Returns:
            PkgJobs() object

        Raises:
            MemoryError, PkgJobsSolveError, PkgAccessError
        
        """
        cdef int rc = c_pkg.EPKG_OK
        cdef c_pkg.pkg_jobs *jobs = NULL
        cdef unsigned flags        = c_pkg.PKG_FLAG_FORCE
        cdef unsigned mode_access  = c_pkg.PKGDB_MODE_READ | c_pkg.PKGDB_MODE_WRITE
        cdef unsigned db_access    = c_pkg.PKGDB_DB_LOCAL
        jobs_obj = PkgJobs()

        # check if we have enough permissions to autoremove packages
        rc = c_pkg.pkgdb_access(mode=mode_access, database=db_access)
        
        if rc != c_pkg.EPKG_OK:
            raise PkgAccessError, 'Insufficient permissions to autoremove packages'
            
        # TODO: Implement setting the rest of the pkg_flags types
    
        rc = c_pkg.pkg_jobs_new(jobs=&jobs, type=c_pkg.PKG_JOBS_AUTOREMOVE, db=self._db)

        if rc != c_pkg.EPKG_OK:
            raise MemoryError, 'Cannot create a jobs object'

        c_pkg.pkg_jobs_set_flags(jobs=jobs, flags=flags)
        
        rc = c_pkg.pkg_jobs_solve(jobs=jobs)
        
        if rc != c_pkg.EPKG_OK:
            raise PkgJobsSolveError, 'Cannot solve package jobs'
        
        jobs_obj._init(jobs)
        self._jobs = jobs
        
        return jobs_obj

    cpdef upgrade(self):
        """
        Return a PkgJobs() object with packages ready to be upgraded.
        
        Queries the remote database for packages which can be upgraded.
        
        Returns:
            PkgJobs() object
        
        Raises:
            MemoryError, PkgJobsSolveError, PkgAccessError
        
        """
        cdef int rc = c_pkg.EPKG_OK
        cdef c_pkg.pkg_jobs *jobs = NULL
        cdef unsigned flags        = c_pkg.PKG_FLAG_NONE | c_pkg.PKG_FLAG_PKG_VERSION_TEST
        cdef unsigned mode_access  = (c_pkg.PKGDB_MODE_READ  |
                                      c_pkg.PKGDB_MODE_WRITE |
                                      c_pkg.PKGDB_MODE_CREATE)
        cdef unsigned db_access    = c_pkg.PKGDB_DB_LOCAL | c_pkg.PKGDB_DB_REPO
        jobs_obj = PkgJobs()
        
        # check if we have enough permissions to upgrade packages
        rc = c_pkg.pkgdb_access(mode=mode_access, database=db_access)

        if rc != c_pkg.EPKG_OK:
            raise PkgAccessError, 'Insufficient permissions to upgrade packages'

        # re-open the database in remote mode if needed
        rc = c_pkg.pkgdb_open(db=&self._db, db_type=c_pkg.PKGDB_REMOTE)

        if rc != c_pkg.EPKG_OK:
            raise IOError, 'Cannot open the database in remote mode'
            
        # TODO: Implement setting the rest of the pkg_flags types

        rc = c_pkg.pkg_jobs_new(jobs=&jobs, type=c_pkg.PKG_JOBS_UPGRADE, db=self._db)
        
        if rc != c_pkg.EPKG_OK:
            raise MemoryError, 'Cannot create a jobs object'
            
        c_pkg.pkg_jobs_set_flags(jobs=jobs, flags=flags)
        
        rc = c_pkg.pkg_jobs_solve(jobs=jobs)
        
        if rc != c_pkg.EPKG_OK:
            raise PkgJobsSolveError, 'Cannot solve package jobs'
            
        jobs_obj._init(jobs)
        self._jobs = jobs
        
        return jobs_obj
        
cdef class PkgDbIter(object):
    """
    Package database iterator

    """
    cdef c_pkg.pkgdb_it *_it
    cdef unsigned _flags

    def __cinit__(self):
        """
        Create a package database iterator.

        Returns:
            None

        """
        self._flags = c_pkg.PKG_LOAD_BASIC

    cdef _init(self, c_pkg.pkgdb_it *it):
        """
        Set the C pointer database iterator for the object.

        Sets the database iterator attribute to the C pointer database iterator.

        Kwargs:
            it (struct pkgdb_it *): C pointer database iterator

        Returns:
            None

        """
        self._it = it
        
    def __dealloc__(self):
        """
        Deallocate the C pointer database iterator.

        Releases any resources taken by the C pointer database iterator

        Returns:
            None

        """
        c_pkg.pkgdb_it_free(it=self._it)

    def __iter__(self):
        return self

    def __next__(self):
        """
        Return the next package from the database iterator.

        Steps through the sequence of packages in the iterator
        and returns the next one in row.

        Returns:
            Pkg() object

        Raises:
            StopIteration

        """
        cdef c_pkg.pkg *pkg = NULL
        pkg_obj = Pkg()
        
        result = c_pkg.pkgdb_it_next(it=self._it, pkg=&pkg, flags=self._flags)

        if result != c_pkg.EPKG_OK:
            c_pkg.pkgdb_it_reset(it=self._it)
            raise StopIteration

        pkg_obj._init(pkg)
            
        return pkg_obj

    def __len__(self):
        """
        Return the number of packages in the iterator.

        Returns:
            Number of packages in the iterator

        """
        cdef unsigned i = 0

        c_pkg.pkgdb_it_reset(it=self._it)
        
        for p in self:
            i += 1

        return i
        
    def __contains__(self, name):
        """
        Test if a package is contained within the database iterator

        Arguments:
            name (str): Package name or origin

        Returns:
            True if package exists, False otherwise

        """
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
        
