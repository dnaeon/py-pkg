
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

    ctypedef pkg_error_t:
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
        EPKG_INSECURE

    int pkg_init(const char *path)
    int pkg_initialized()
    int pkg_shutdown()

    int   pkgdb_open(pkgdb **db, pkgdb_t db_type)
    void  pkgdb_close(pkgdb *db)
