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

    # Database type
    ctypedef enum pkgdb_t:
        PKGDB_DEFAULT = 0,
        PKGDB_REMOTE

    # Package type
    ctypedef enum pkg_t:
        PKG_NONE       = 0,
        PKG_FILE       = (1 << 0),
        PKG_REMOTE     = (1 << 1),
        PKG_INSTALLED  = (1 << 2),
        PKG_OLD_FILE   = (1 << 3),

    # Package errors
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

    # Match types used for specifying how we match packages
    ctypedef enum match_t:
        MATCH_ALL = 0,
        MATCH_EXACT,
        MATCH_GLOB,
        MATCH_REGEX,
        MATCH_CONDITION,

    # Flags for loading different attributes of a package
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

    # Package attributes
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
        PKG_REPOPATH,
        PKG_CKSUM,
        PKG_OLD_VERSION,
        PKG_REPONAME,
        PKG_REPOURL,
        PKG_DIGEST,
        PKG_REASON,
        # end of fields
        PKG_FLATSIZE = 64,
        PKG_OLD_FLATSIZE,
        PKG_PKGSIZE,
        PKG_LICENSE_LOGIC,
        PKG_AUTOMATIC,
        PKG_LOCKED,
        PKG_ROWID,
        PKG_TIME,

    # Package dependency attributes
    ctypedef enum pkg_dep_attr:
        PKG_DEP_NAME = 0,
        PKG_DEP_ORIGIN,
        PKG_DEP_VERSION,

    # License logic types
    ctypedef enum lic_t:
        LICENSE_OR     = 124, # '|'
        LICENSE_AND    = 38,  # '&'
        LICENSE_SINGLE = 1,

    # Package file attributes
    ctypedef enum pkg_file_attr:
        PKG_FILE_PATH = 0,
        PKG_FILE_SUM,
        PKG_FILE_UNAME,
        PKG_FILE_GNAME,

    # Package directory attributes
    ctypedef enum pkg_dir_attr:
        PKG_DIR_PATH = 0,
        PKG_DIR_UNAME,
        PKG_DIR_GNAME,

    # Package job types
    ctypedef enum pkg_jobs_t:
        PKG_JOBS_INSTALL = 0,
        PKG_JOBS_DEINSTALL,
        PKG_JOBS_FETCH,
        PKG_JOBS_AUTOREMOVE,
        PKG_JOBS_UPGRADE,

    # Package flags used when performing an action like installation, deinstallation, etc. of packages
    ctypedef enum pkg_flags:
        PKG_FLAG_NONE                   = 0,
        PKG_FLAG_DRY_RUN                = (1 << 0),
        PKG_FLAG_FORCE                  = (1 << 1),
        PKG_FLAG_RECURSIVE              = (1 << 2),
        PKG_FLAG_AUTOMATIC              = (1 << 3),
        PKG_FLAG_WITH_DEPS              = (1 << 4),
        PKG_FLAG_NOSCRIPT               = (1 << 5),
        PKG_FLAG_PKG_VERSION_TEST       = (1 << 6),
        PKG_FLAG_UPGRADES_FOR_INSTALLED = (1 << 7),
        PKG_FLAG_SKIP_INSTALL           = (1 << 8)

    # Flags for testing access to the database file
    ctypedef enum pkgdb_access_perm_t:
        PKGDB_MODE_READ   = (0x1<<0),
        PKGDB_MODE_WRITE  = (0x1<<1),
        PKGDB_MODE_CREATE = (0x1<<2)

    # Flags for testing access to the databases
    ctypedef enum pkgdb_access_db_t:
        PKGDB_DB_LOCAL    = (0x1<<0),
        PKGDB_DB_REPO     = (0x1<<1)

    # Package repository mirror type
    ctypedef enum mirror_t:
        SRV = 0,
        HTTP,
        NOMIRROR,
        
    int pkg_init(const char *path)
    int pkg_initialized()
    int pkg_shutdown()

    int   pkgdb_open(pkgdb **db,
                     pkgdb_t db_type)

    void  pkgdb_close(pkgdb *db)

    int pkgdb_access(unsigned mode, unsigned database)
    
    pkgdb_it *pkgdb_query(pkgdb *db,
                          const char *pattern,
                          match_t match)

    pkgdb_it *pkgdb_rquery(pkgdb *db,
                           const char *pattern,
                           match_t match,
                           const char *reponame)
    
    int pkgdb_it_next(pkgdb_it *it, pkg **pkg, unsigned flags)

    void pkgdb_it_reset(pkgdb_it *it)

    void pkgdb_it_free(pkgdb_it *it)

    void pkg_free(pkg *pkg)
    
    int pkg_get(const pkg *pkg, ...)

    const char *pkg_dep_get(pkg_dep *dep, pkg_dep_attr attr)
    int pkg_deps(const pkg *pkg, pkg_dep **dep)

    int pkg_rdeps(const pkg *pkg, pkg_dep **dep)

    int pkg_files(const pkg *pkg, pkg_file **file)
    const char *pkg_file_get(pkg_file *file, const pkg_file_attr attr)
    
    int pkg_dirs(const pkg *pkg, pkg_dir **dir)
    const char *pkg_dir_get(pkg_dir *dir, const pkg_dir_attr attr)
    
    int pkg_categories(const pkg *pkg, pkg_category **category)
    const char *pkg_category_name(pkg_category *category)

    int pkg_options(const pkg *pkg, pkg_option **option)
    const char *pkg_option_opt(const pkg_option *option)
    const char *pkg_option_value(const pkg_option *option)
    
    int pkg_licenses(const pkg *pkg, pkg_license **license)
    const char *pkg_license_name(const pkg_license *license)
    
    int pkg_users(const pkg *pkg, pkg_user **user)
    const char *pkg_user_name(const pkg_user *user)
    const char *pkg_user_uidstr(const pkg_user *user)
    
    int pkg_groups(const pkg *pkg, pkg_group **group)
    const char *pkg_group_name(const pkg_group *group)
    const char *pkg_group_gidstr(const pkg_group *group)

    int pkg_shlibs_required(const pkg *pkg, pkg_shlib **shlib)
    int pkg_shlibs_provided(const pkg *pkg, pkg_shlib **shlib)
    const char *pkg_shlib_name(const pkg_shlib *shlib)

    int pkg_jobs_new(pkg_jobs **jobs, pkg_jobs_t type, pkgdb *db)
    void pkg_jobs_free(pkg_jobs *jobs)
    int pkg_jobs_add(pkg_jobs *jobs, match_t match, char **argv, int argc)
    int pkg_jobs_solve(pkg_jobs *jobs)
    int pkg_jobs_find(pkg_jobs *jobs, const char *origin, pkg **pkg)
    int pkg_jobs_set_repository(pkg_jobs *jobs, const char *name)
    void pkg_jobs_set_flags(pkg_jobs *jobs, unsigned flags)
    pkg_jobs_t pkg_jobs_type(pkg_jobs *jobs)
    int pkg_jobs_next "pkg_jobs"(pkg_jobs *jobs, pkg **pkg)
    int pkg_jobs_count(pkg_jobs *jobs)
    int pkg_jobs_apply(pkg_jobs *jobs)
    
    pkg_t pkg_type(const pkg *pkg)

    int pkg_repos(pkg_repo **repo)
    const char *pkg_repo_url(pkg_repo *repo)
    const char *pkg_repo_ident(pkg_repo *repo)
    const char *pkg_repo_name(pkg_repo *repo)
    const char *pkg_repo_key(pkg_repo *repo)
    bint pkg_repo_enabled(pkg_repo *repo)
    mirror_t pkg_repo_mirror_type(pkg_repo *repo)
    pkg_repo *pkg_repo_find_ident(const char *ident)
    pkg_repo *pkg_repo_find_name(const char *name)
    
    int pkg_update(pkg_repo *repo, bint force)
    
