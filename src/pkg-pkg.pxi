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

cdef class Pkg(object):  
    cdef c_pkg.pkg *_pkg
    cdef const char *_attr_str
    cdef bint _attr_bool
    cdef unsigned int _attr_int

    def __cinit__(self):
        self._attr_str = NULL
        self._attr_bool = False
        self._attr_int = 0
        
    cdef _init(self, c_pkg.pkg *pkg):
        self._pkg = pkg
        
    def __dealloc__(self):
        c_pkg.pkg_free(pkg=self._pkg)

    def __str__(self):
        return '%s-%s' % (self.name(), self.version())

    cdef pkg_get_attr_str(self, c_pkg.pkg_attr attr, types):
        if types and c_pkg.pkg_type(pkg=self._pkg) not in types:
            raise PkgTypeError, 'Requested attribute is not applicable to the package type'
        
        c_pkg.pkg_get(self._pkg, attr, &self._attr_str)

        return self._attr_str

    cdef pkg_get_attr_bool(self, c_pkg.pkg_attr attr, types):
        if types and c_pkg.pkg_type(pkg=self._pkg) not in types:
            raise PkgTypeError, 'Requested attribute is not applicable to the package type'
            
        c_pkg.pkg_get(self._pkg, attr, &self._attr_bool)

        return self._attr_bool

    cdef pkg_get_attr_int(self, c_pkg.pkg_attr attr, types):
        if types and c_pkg.pkg_type(pkg=self._pkg) not in types:
            raise PkgTypeError, 'Requested attribute is not applicable to the package type'
            
        c_pkg.pkg_get(self._pkg, attr, &self._attr_int)

        return self._attr_int
        
    cpdef origin(self):
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_ORIGIN, _pkg_type)
        
    cpdef name(self):
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_NAME, _pkg_type)

    cpdef version(self):
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_VERSION, _pkg_type)

    cpdef comment(self):
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_COMMENT, _pkg_type)

    cpdef desc(self):
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_DESC, _pkg_type)

    cpdef mtree(self):
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_MTREE, _pkg_type)

    cpdef message(self):
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_MESSAGE, _pkg_type)

    cpdef arch(self):
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_ARCH, _pkg_type)

    cpdef maintainer(self):
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_MAINTAINER, _pkg_type)

    cpdef www(self):
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_WWW, _pkg_type)

    cpdef prefix(self):
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_PREFIX, _pkg_type)

    cpdef infos(self):
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_INFOS, _pkg_type)

    cpdef repopath(self):
        _pkg_type = [c_pkg.PKG_REMOTE]
        
        return self.pkg_get_attr_str(c_pkg.PKG_REPOPATH, _pkg_type)

    cpdef cksum(self):
        _pkg_type = [c_pkg.PKG_REMOTE]
        
        return self.pkg_get_attr_str(c_pkg.PKG_CKSUM, _pkg_type)

    cpdef old_version(self):
        _pkg_type = [c_pkg.PKG_REMOTE]
        
        return self.pkg_get_attr_str(c_pkg.PKG_OLD_VERSION, _pkg_type)

    cpdef reponame(self):
        _pkg_type = [c_pkg.PKG_REMOTE]
        
        return self.pkg_get_attr_str(c_pkg.PKG_REPONAME, _pkg_type)

    cpdef repourl(self):
        _pkg_type = [c_pkg.PKG_REMOTE]
        
        return self.pkg_get_attr_str(c_pkg.PKG_REPOURL, _pkg_type)

    cpdef digest(self):
        _pkg_type = [c_pkg.PKG_REMOTE]
        
        return self.pkg_get_attr_str(c_pkg.PKG_DIGEST, _pkg_type)

    cpdef reason(self):
        _pkg_type = [c_pkg.PKG_REMOTE]
        
        return self.pkg_get_attr_str(c_pkg.PKG_REASON, _pkg_type)
        
    cpdef old_flatsize(self):
        return self.pkg_get_attr_int(c_pkg.PKG_OLD_FLATSIZE, None)

    cpdef size(self):
        return self.pkg_get_attr_int(c_pkg.PKG_FLATSIZE, None)

    cpdef license_logic(self):
        return self.pkg_get_attr_int(c_pkg.PKG_LICENSE_LOGIC, None)

    cpdef automatic(self):
        return self.pkg_get_attr_bool(c_pkg.PKG_AUTOMATIC, None)

    cpdef locked(self):
        return self.pkg_get_attr_bool(c_pkg.PKG_LOCKED, None)

    cpdef rowid(self):
        return self.pkg_get_attr_int(c_pkg.PKG_ROWID, None)

    cpdef time(self):
        return self.pkg_get_attr_int(c_pkg.PKG_TIME, None)

    cpdef deps(self):
        deps_iter_obj = PkgDepIter()
        deps_iter_obj._init(self._pkg)

        return deps_iter_obj

    cpdef rdeps(self):
        rdeps_iter_obj = PkgRdepIter()
        rdeps_iter_obj._init(self._pkg)

        return rdeps_iter_obj

    cpdef files(self):
        files_iter_obj = PkgFileIter()
        files_iter_obj._init(self._pkg)

        return files_iter_obj

    cpdef dirs(self):
        dirs_iter_obj = PkgDirIter()
        dirs_iter_obj._init(self._pkg)

        return dirs_iter_obj

    cpdef categories(self):
        categories_iter_obj = PkgCategoryIter()
        categories_iter_obj._init(self._pkg)

        return categories_iter_obj

    cpdef options(self):
        options_iter_obj = PkgOptionIter()
        options_iter_obj._init(self._pkg)

        return options_iter_obj

    cpdef licenses(self):
        licenses_iter_obj = PkgLicenseIter()
        licenses_iter_obj._init(self._pkg)

        return licenses_iter_obj
    
    cpdef users(self):
        users_iter_obj = PkgUserIter()
        users_iter_obj._init(self._pkg)

        return users_iter_obj

    cpdef groups(self):
        groups_iter_obj = PkgGroupIter()
        groups_iter_obj._init(self._pkg)

        return groups_iter_obj

    cpdef shlibs_required(self):
        shlibs_required_iter_obj = PkgShlibsRequiredIter()
        shlibs_required_iter_obj._init(self._pkg)

        return shlibs_required_iter_obj

    cpdef shlibs_provided(self):
        shlibs_provided_iter_obj = PkgShlibsProvidedIter()
        shlibs_provided_iter_obj._init(self._pkg)

        return shlibs_provided_iter_obj
