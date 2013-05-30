
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

    ctypedef enum pkg_load_flags_t:
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

    ctypedef enum pkg_attr:
        PKG_ORIGIN = 1,
        PKG_NAME,
        PKG_VERSION,
        PKG_COMMENT,
        PKG_DESC,
        PKG_MTREE,
        PKG_MESSAGE,
        PKG_ARCH,
        PKG_MAINTAINER,
        PKG_WWW,
        PKG_PREFIX,
        PKG_INFOS,
        PKG_REPOPATH,
        PKG_CKSUM,
        PKG_OLD_VERSION,
        PKG_REPONAME,
        PKG_REPOURL,
        PKG_DIGEST,
        # end of fields
        PKG_FLATSIZE = 64,
        PKG_OLD_FLATSIZE,
        PKG_PKGSIZE,
        PKG_LICENSE_LOGIC,
        PKG_AUTOMATIC,
        PKG_LOCKED,
        PKG_ROWID,
        PKG_TIME,

    ctypedef enum pkg_dep_attr:
        PKG_DEP_NAME = 0,
        PKG_DEP_ORIGIN,
        PKG_DEP_VERSION,

    ctypedef enum lic_t:
        LICENSE_OR     = 124, # '|'
        LICENSE_AND    = 38,  # '&'
        LICENSE_SINGLE = 1,

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

    void pkgdb_it_reset(pkgdb_it *it)

    void pkgdb_it_free(pkgdb_it *it)

    void pkg_free(pkg *pkg)
    
    int pkg_get(const pkg *pkg, ...)

    const char *pkg_dep_get(pkg_dep *dep, pkg_dep_attr attr)
    int pkg_deps(const pkg *pkg, pkg_dep **dep)
    int pkg_rdeps(const pkg *pkg, pkg_dep **dep)
    
    
