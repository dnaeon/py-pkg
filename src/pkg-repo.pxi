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

cdef class PkgRepo(object):
    """
    Package repository object.

    Provides methods for accessing various attributes of a package repository.

    """
    cdef c_pkg.pkg_repo *_repo

    def __cinit__(self):
        """
        Initializes a new package repository object.

        """
        self._repo = NULL

    cdef _init(self, c_pkg.pkg_repo *repo):
        """
        Set the C pointer of a package repository object.

        """
        self._repo = repo

    def __dealloc__(self):
        """
        Release any previously allocated resources.

        """
        pass

    def __str__(self):
        """
        String representation of a package repository object.

        Returns:
            String object representing the package repository in the form of:
            '<repo-name>: <repo-url>'

        """
        return '%s: %s' % (self.name(), self.url())
        
    cpdef name(self):
        """
        Retrieve the package repository name.
        
        Returns:
            A string object representing the package repository name
        
        """
        return c_pkg.pkg_repo_name(repo=self._repo)

    cpdef url(self):
        """
        Retrieve the package repository URL.
        
        Returns:
            A string object representing the package repository URL
        
        """
        return c_pkg.pkg_repo_url(repo=self._repo)

    cpdef key(self):
        """
        Retrieve the package repository key.

        Returns:
            A string object representing the key used to sign a package repository.

        """
        return c_pkg.pkg_repo_key(repo=self._repo)

    cpdef ident(self):
        """
        Retrieve the package repository ident.

        Returns:
            A string object representing the repository ident.

        """
        return c_pkg.pkg_repo_ident(repo=self._repo)

    cpdef enabled(self):
        """
        Return True if a repository is enabled, False otherwise.

        """
        return c_pkg.pkg_repo_enabled(repo=self._repo)

    cpdef mirror_type(self):
        """
        Return the mirror type of the package repository.

        """
        result = c_pkg.pkg_repo_mirror_type(repo=self._repo)

        if result == c_pkg.SRV:
            return 'SRV'
        elif result == c_pkg.HTTP:
            return 'HTTP'
        elif result == c_pkg.NOMIRROR:
            return 'NOMIRROR'
        else:
            return 'UNKNOWN'
        
cdef class PkgRepoIter(object):
    """
    Package repository iterator object.

    Provides a mechanism for iterating over the package repositories.

    """
    cdef c_pkg.pkg_repo *_repo

    def __cinit__(self):
        """
        Initializes a new repository iterator object.

        """
        self._repo = NULL

    def __dealloc__(self):
        """
        Release any previously allocated resources.

        """
        pass

    def __iter__(self):
        return self

    def __len__(self):
        """
        Return the number of package repositories.
        
        """
        cdef unsigned i = 0

        for r in self:
            i += 1

        return i

    def __contains__(self, name):
        """
        Test if a repository exists.
        
        Arguments:
            name (str): Name or URL of the repository

        Returns:
            True if the repository exists, False otherwise.

        """
        for r in self:
            if r.name() == name or r.url() == name:
                return True

        return False

    def __next__(self):
        """
        Return the next package repository.

        Returns:
            PkgRepo() object

        Raises:
            StopIteration

        """
        result = c_pkg.pkg_repos(repo=&self._repo)

        if result != c_pkg.EPKG_OK:
            raise StopIteration

        pkg_repo_obj = PkgRepo()
        pkg_repo_obj._init(self._repo)

        return pkg_repo_obj
