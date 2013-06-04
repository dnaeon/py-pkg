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
    """
    Package object.

    Provides methods for accessing various package attributes.

    """
    cdef c_pkg.pkg *_pkg
    cdef const char *_attr_str
    cdef bint _attr_bool
    cdef unsigned int _attr_int

    def __cinit__(self):
        """
        Initializes a new package object.

        """
        self._attr_str = NULL
        self._attr_bool = False
        self._attr_int = 0
        
    cdef _init(self, c_pkg.pkg *pkg):
        """
        Sets the C pointer package.

        Sets the C pointer representing the package.

        Kwargs:
            pkg (struct pkg *): A valid C package pointer

        Returns:
            None

        """
        self._pkg = pkg
        
    def __dealloc__(self):
        """
        Deallocate any previously allocated resoures.

        Releases the memory allocated for the C package pointer struct.

        Returns:
            None

        """
        c_pkg.pkg_free(pkg=self._pkg)

    def __str__(self):
        """
        String representation of a package object.

        Returns:
            A '<name>-<version>' string representation of the package.

        """
        return '%s-%s' % (self.name(), self.version())

    cdef pkg_get_attr_str(self, c_pkg.pkg_attr attr, types):
        """
        Retrieve a package attribute that is a string.

        The 'types' argument should be set to a list of
        valid package types (e.g. PKG_FILE, PKG_REMOTE, etc.),
        against which the package is being tested for before
        attempting to return it's attribute, or None if the attribute is
        applicable to all package types.
        
        Kwargs:
            attr  (pkg_attr) : Package attribute to retrieve
            types (list)     : A list of pkg_type types

        Returns:
            The requested string attribute

        Raises:
            PkgTypeError

        """
        if types and c_pkg.pkg_type(pkg=self._pkg) not in types:
            raise PkgTypeError, 'Requested attribute is not applicable to the package type'
        
        c_pkg.pkg_get(self._pkg, attr, &self._attr_str)

        return self._attr_str

    cdef pkg_get_attr_bool(self, c_pkg.pkg_attr attr, types):
        """
        Retrieve a package attribute that is a boolean value.
        
        The 'types' argument should be set to a list of
        valid package types (e.g. PKG_FILE, PKG_REMOTE, etc.),
        against which the package is being tested for before
        attempting to return it's attribute, or None if the attribute is
        applicable to all package types.
        
        Kwargs:
            attr  (pkg_attr) : Package attribute to retrieve
            types (list)     : A list of pkg_type types
        
        Returns:
            A boolean value
        
        Raises:
            PkgTypeError
        
        """
        if types and c_pkg.pkg_type(pkg=self._pkg) not in types:
            raise PkgTypeError, 'Requested attribute is not applicable to the package type'
            
        c_pkg.pkg_get(self._pkg, attr, &self._attr_bool)

        return self._attr_bool

    cdef pkg_get_attr_int(self, c_pkg.pkg_attr attr, types):
        """
        Retrieve a package attribute that is an integer/long value.
        
        The 'types' argument should be set to a list of
        valid package types (e.g. PKG_FILE, PKG_REMOTE, etc.),
        against which the package is being tested for before
        attempting to return it's attribute, or None if the attribute is
        applicable to all package types.
        
        Kwargs:
            attr  (pkg_attr) : Package attribute to retrieve
            types (list)     : A list of pkg_type types
        
        Returns:
            An integer value
        
        Raises:
            PkgTypeError
        
        """
        if types and c_pkg.pkg_type(pkg=self._pkg) not in types:
            raise PkgTypeError, 'Requested attribute is not applicable to the package type'
            
        c_pkg.pkg_get(self._pkg, attr, &self._attr_int)

        return self._attr_int
        
    cpdef origin(self):
        """
        Retrieve the package origin.

        Retrieves and returns the package origin, e.g. 'shells/zsh'.

        Returns:
            A string object representing the package origin

        """
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_ORIGIN, _pkg_type)
        
    cpdef name(self):
        """
        Retrieve the package name.
        
        Retrieves and returns the package name, e.g. 'zsh'.
        
        Returns:
            A string object representing the package name
        
        """
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_NAME, _pkg_type)

    cpdef version(self):
        """
        Retrieve the package version.
        
        Retrieves and returns the package version, e.g. 'x.y.z-b1'.
        
        Returns:
            A string object representing the package version

        """
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_VERSION, _pkg_type)

    cpdef comment(self):
        """
        Retrieve the package comment.
        
        Retrieves and returns the one-line package comment.
        
        Returns:
            A string object representing the package comment

        """
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_COMMENT, _pkg_type)

    cpdef desc(self):
        """
        Retrieve the package description.
        
        Retrieves and returns the package description, a text providing
        more information about the package.
        
        Returns:
            A string object representing the package description
        
        """
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_DESC, _pkg_type)

    cpdef mtree(self):
        """
        Retrieve the package directory hierarchy.

        Retrieves and returns the package directory hierarchy, aka package mtree(8).

        Returns:
            A string object representing the package mtree(8)
        
        """
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_MTREE, _pkg_type)

    cpdef message(self):
        """
        Retrieve the package message.
        
        Retrieves and returns the package message, usually containing
        further instructions on how to start/stop/manage the specific
        package in question.
        
        Returns:
            A string object representing the package message
        
        """
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_MESSAGE, _pkg_type)

    cpdef arch(self):
        """
        Retrieve the package arch.
        
        Retrieves and returns the package arch, showing the platform
        for which this package is intended for and has been built on.
        
        Returns:
            A string object representing the package arch
        
        """
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_ARCH, _pkg_type)

    cpdef maintainer(self):
        """
        Retrieve the package maintainer.
        
        Retrieves and returns the package maintainer, e.g. dnaeon@gmail.com
        
        Returns:
            A string object representing the package origin

        """
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_MAINTAINER, _pkg_type)

    cpdef www(self):
        """
        Retrieve the package web site.
        
        Retrieves and returns the package web site if the package provides any.
        
        Returns:
            A string object representing the package web site

        """
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_WWW, _pkg_type)

    cpdef prefix(self):
        """
        Retrieve the package prefix.
        
        Retrieves and returns the package prefix, e.g. '/usr/local'
        
        Returns:
            A string object representing the package prefix
        
        """
        _pkg_type = [c_pkg.PKG_FILE, c_pkg.PKG_REMOTE, c_pkg.PKG_INSTALLED]
        
        return self.pkg_get_attr_str(c_pkg.PKG_PREFIX, _pkg_type)

    cpdef repopath(self):
        """
        Retrieve the package repository path.
        
        Retrieves and returns the package repository path,
        which is the location of the package on the remote repository.
        
        Returns:
            A string object representing the package repo path
        
        """
        _pkg_type = [c_pkg.PKG_REMOTE]
        
        return self.pkg_get_attr_str(c_pkg.PKG_REPOPATH, _pkg_type)

    cpdef cksum(self):
        """
        Retrieve the package checksum.
        
        Retrieves and returns the checksum of a remote package.
        
        Returns:
            A string object representing the package checksum
        
        """
        _pkg_type = [c_pkg.PKG_REMOTE]
        
        return self.pkg_get_attr_str(c_pkg.PKG_CKSUM, _pkg_type)

    cpdef old_version(self):
        """
        Retrieve the package old version.
        
        Retrieves and returns the package old version, e.g.
        previous version of package before attempting an upgrade.
        
        Returns:
            A string object representing the old package version
        
        """
        _pkg_type = [c_pkg.PKG_REMOTE]
        
        return self.pkg_get_attr_str(c_pkg.PKG_OLD_VERSION, _pkg_type)

    cpdef reponame(self):
        """
        Retrieve the package repository name.
        
        Retrieves and returns the package repository name.
        
        Returns:
            A string object representing the package repository name
        
        """
        _pkg_type = [c_pkg.PKG_REMOTE]
        
        return self.pkg_get_attr_str(c_pkg.PKG_REPONAME, _pkg_type)

    cpdef repourl(self):
        """
        Retrieve the package repository URL.
        
        Retrieves and returns the package repository URL.
        
        Returns:
            A string object representing the package repository URL
        
        """
        _pkg_type = [c_pkg.PKG_REMOTE]
        
        return self.pkg_get_attr_str(c_pkg.PKG_REPOURL, _pkg_type)

    cpdef digest(self):
        """
        Retrieve the package digest.
        
        Retrieves and returns the package digest.
        
        Returns:
            A string object representing the package digest
        
        """
        _pkg_type = [c_pkg.PKG_REMOTE]
        
        return self.pkg_get_attr_str(c_pkg.PKG_DIGEST, _pkg_type)

    cpdef reason(self):
        """
        Retrieve any reasons assigned to a package.
        
        Retrieves and returns reasons assigned to a package, if any.
        A reasons assigned to package contains information about
        why a package is being reinstalled for example.
        
        Returns:
            A string object representing the reason
    
        """
        _pkg_type = [c_pkg.PKG_REMOTE]
        
        return self.pkg_get_attr_str(c_pkg.PKG_REASON, _pkg_type)
        
    cpdef old_flatsize(self):
        """
        Retrieve the package old flatsize.
        
        Retrieves and returns the package old flatsize, e.g.
        previous flatsize of a package before attempting an upgrade.
        
        Returns:
            Integer object representing the old package flatsize

        """
        return self.pkg_get_attr_int(c_pkg.PKG_OLD_FLATSIZE, None)

    cpdef size(self):
        """
        Retrieve the package old size.
        
        Retrieves and returns the package size.
        
        Returns:
            Integer object representing the package size
        
        """
        return self.pkg_get_attr_int(c_pkg.PKG_FLATSIZE, None)

    cpdef license_logic(self):
        """
        Retrieve the package license logic.
        
        Retrieves and returns the package license logic.
        
        Returns:
            Integer object representing the license logic.
        
        """
        return self.pkg_get_attr_int(c_pkg.PKG_LICENSE_LOGIC, None)

    cpdef automatic(self):
        """
        Check if a package is marked as automatic.
        
        Checks if a package is marked as automatic, and thus
        can be autoremoved.
        
        Returns:
            True if package is automatic, False otherwise.
        
        """
        return self.pkg_get_attr_bool(c_pkg.PKG_AUTOMATIC, None)

    cpdef locked(self):
        """
        Check if a package is locked.
        
        Locking of packages prevents against reinstallation, modification or
        deletion of the package. 
        
        Returns:
            True if package is locked, False otherwise.
        
        """
        return self.pkg_get_attr_bool(c_pkg.PKG_LOCKED, None)

    cpdef rowid(self):
        """
        Retrieve the package row id from the database.
        
        Retrieve and return the package row id from the package database.
        
        Returns:
            Integer object representing the package row id.
        
        """
        return self.pkg_get_attr_int(c_pkg.PKG_ROWID, None)

    cpdef time(self):
        """
        Retrieve the package installation time.

        Retrieve and return the time a package has been installed.

        Returns:
            Time the package has been installed in seconds since the Epoch.

        """
        return self.pkg_get_attr_int(c_pkg.PKG_TIME, None)

    cpdef deps(self):
        """
        Iterate over the package dependencies.
        
        Creates an iterator that loops over the package dependencies.
        
        Returns:
            A PkgDepIter() object suitable for iterating over the package dependencies.
        
        """
        deps_iter_obj = PkgDepIter()
        deps_iter_obj._init(self._pkg)

        return deps_iter_obj

    cpdef rdeps(self):
        """
        Iterate over the reverse package dependencies.
        
        Creates an iterator that loops over the reverse package dependencies.
        
        Returns:
            A PkgRDepIter() object suitable for iterating over the reverse package dependencies.
    
        """
        rdeps_iter_obj = PkgRdepIter()
        rdeps_iter_obj._init(self._pkg)

        return rdeps_iter_obj

    cpdef files(self):
        """
        Iterate over the package files.
        
        Creates an iterator that loops over the files provided by a package.
        
        Returns:
            A PkgFileIter() object suitable for iterating over the package files.
        
        """
        files_iter_obj = PkgFileIter()
        files_iter_obj._init(self._pkg)

        return files_iter_obj

    cpdef dirs(self):
        """
        Iterate over the package directories.
        
        Creates an iterator that loops over the directories provided by a package.
        
        Returns:
            A PkgDirIter() object suitable for iterating over the package directories.
        
        """
        dirs_iter_obj = PkgDirIter()
        dirs_iter_obj._init(self._pkg)

        return dirs_iter_obj

    cpdef categories(self):
        """
        Iterate over the package categories.
        
        Creates an iterator that loops over the package categories.
        
        Returns:
            A PkgCategoryIter() object suitable for iterating over the package categories.
    
        """
        categories_iter_obj = PkgCategoryIter()
        categories_iter_obj._init(self._pkg)

        return categories_iter_obj

    cpdef options(self):
        """
        Iterate over the package options.
        
        Creates an iterator that loops over the package options.
        
        Returns:
            A PkgOptionIter() object suitable for iterating over the package options.
        
        """
        options_iter_obj = PkgOptionIter()
        options_iter_obj._init(self._pkg)

        return options_iter_obj

    cpdef licenses(self):
        """
        Iterate over the package licenses.
        
        Creates an iterator that loops over the package licenses.

        Returns:
        A PkgLicenseIter() object suitable for iterating over the package licenses.
        
        """
        licenses_iter_obj = PkgLicenseIter()
        licenses_iter_obj._init(self._pkg)

        return licenses_iter_obj
    
    cpdef users(self):
        """
        Iterate over the package users.

        Creates an iterator that loops over the users created/needed by the package.

        Returns:
        A PkgUserIter() object suitable for iterating over the package users.
        
        """
        users_iter_obj = PkgUserIter()
        users_iter_obj._init(self._pkg)

        return users_iter_obj

    cpdef groups(self):
        """
        Iterate over the package groups.
        
        Creates an iterator that loops over the groups created/needed by the package.
        
        Returns:
            A PkgGroupIter() object suitable for iterating over the package users.
        
        """
        groups_iter_obj = PkgGroupIter()
        groups_iter_obj._init(self._pkg)

        return groups_iter_obj

    cpdef shlibs_required(self):
        """
        Iterate over the required shared libraries of a package.
        
        Creates an iterator that loops over the required shared libraries of a package.
        
        Returns:
            A PkgShlibsRequiredIter() object suitable for iterating over the required
            shared libraries of the package.
        
        """
        shlibs_required_iter_obj = PkgShlibsRequiredIter()
        shlibs_required_iter_obj._init(self._pkg)

        return shlibs_required_iter_obj

    cpdef shlibs_provided(self):
        """
        Iterate over the provided shared libraries by a package.
        
        Creates an iterator that loops over the shared libraries provided by a package.
        
        Returns:
            A PkgShlibsProvidedIter() object suitable for iterating over the
            shared libraries provided by the package.
        
        """
        shlibs_provided_iter_obj = PkgShlibsProvidedIter()
        shlibs_provided_iter_obj._init(self._pkg)

        return shlibs_provided_iter_obj
