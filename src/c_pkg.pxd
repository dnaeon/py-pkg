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

    ctypedef enum pkg_dep_attr:
        PKG_DEP_NAME = 0,
        PKG_DEP_ORIGIN,
        PKG_DEP_VERSION,

    ctypedef enum lic_t:
        LICENSE_OR     = 124, # '|'
        LICENSE_AND    = 38,  # '&'
        LICENSE_SINGLE = 1,

    ctypedef enum pkg_file_attr:
        PKG_FILE_PATH = 0,
        PKG_FILE_SUM,
        PKG_FILE_UNAME,
        PKG_FILE_GNAME,

    ctypedef enum pkg_dir_attr:
        PKG_DIR_PATH = 0,
        PKG_DIR_UNAME,
        PKG_DIR_GNAME,
    
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
    
    
    
