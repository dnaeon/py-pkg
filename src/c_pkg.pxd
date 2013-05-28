
cdef extern from 'pkg.h':
    cdef struct pkg
    cdef struct pkg_dep
    cdef struct pkg_file
    cdef struct pkg_dir
    cdef struct pkg_category
    cdef struct pkg_option
    cdef struct pkg_license
    cdef struct pkg_user
    cdef struct pkg_group
    cdef struct pkg_shlib
    cdef struct pkg_note

    cdef struct pkgdb
    cdef struct pkgdb_it

    cdef struct pkg_jobs

    cdef struct pkg_repo

    cdef struct pkg_config
    cdef struct pkg_config_kv
    cdef struct pkg_config_value

    cdef struct pkg_plugin

    cdef struct pkg_manifest_key

    ctypedef enum pkgdb_t:
        PKGDB_DEFAULT = 0,
        PKGDB_REMOTE

    ctypedef enum pkg_error_t:
        EPKG_OK = 0,
        EPKG_END,
        EPKG_WARN,
        EPKG_FATAL,
        EPKG_REQUIRED,
        EPKG_INSTALLED,
        EPKG_DEPENDENCY,
        EPKG_LOCKED,
        EPKG_ENODB,
        EPKG_UPTODATE,
        EPKG_UNKNOWN,
        EPKG_REPOSCHEMA,
        EPKG_ENOACCESS,
        EPKG_INSECURE,

    ctypedef enum match_t:
        MATCH_ALL = 0,
        MATCH_EXACT,
        MATCH_GLOB,
        MATCH_REGEX,
        MATCH_CONDITION,

    ctypedef enum pkg_load_flags:
        PKG_LOAD_BASIC            = 0,
        PKG_LOAD_DEPS             = (1 << 0),
        PKG_LOAD_RDEPS            = (1 << 1),
        PKG_LOAD_FILES            = (1 << 2),
        PKG_LOAD_SCRIPTS          = (1 << 3),
        PKG_LOAD_OPTIONS          = (1 << 4),
        PKG_LOAD_MTREE            = (1 << 5),
        PKG_LOAD_DIRS             = (1 << 6),
        PKG_LOAD_CATEGORIES       = (1 << 7),
        PKG_LOAD_LICENSES         = (1 << 8),
        PKG_LOAD_USERS            = (1 << 9),
        PKG_LOAD_GROUPS           = (1 << 10),
        PKG_LOAD_SHLIBS_REQUIRED  = (1 << 11),
        PKG_LOAD_SHLIBS_PROVIDED  = (1 << 12),
        PKG_LOAD_ANNOTATIONS      = (1 << 13),

    int pkg_init(const char *path)
    int pkg_initialized()
    int pkg_shutdown()

    int   pkgdb_open(pkgdb **db,
                     pkgdb_t db_type)

    void  pkgdb_close(pkgdb *db)

    pkgdb_it *pkgdb_query(pkgdb *db,
                          const char *pattern,
                          match_t match)

    int pkgdb_it_next(pkgdb_it *it, pkg **pkg, unsigned flags)

    void pkgdb_it_free(pkgdb_it *it)

    void pkg_free(pkg *pkg)
    
    int pkg_get(const pkg *pkg, ...)
    
