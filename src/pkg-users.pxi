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

cdef class PkgUser(object):
    """
    Package user object.

    Provides methods for accessing attributes of users.

    """
    cdef c_pkg.pkg_user *_user

    def __cinit__(self):
        """
        Initializes a new package user object.

        """
        self._user = NULL

    cdef _init(self, c_pkg.pkg_user *user):
        """
        Set the C pointer of a package user object.

        """
        self._user = user

    def __dealloc__(self):
        """
        Release any previously allocated resources.

        """
        pass

    def __str__(self):
        """
        String representation of a package user object.

        Returns:
            A string object reprensenting the user name

        """
        return '%s' % self.name()
        
    cpdef name(self):
        """
        Retrieve the name of the user.

        Returns:
            A string object representing the package user name
        
        """
        return c_pkg.pkg_user_name(user=self._user)

    cpdef uid(self):
        """
        Retrieve the uid of the user.

        Returns:
            A string object representing the user's uid

        """
        return c_pkg.pkg_user_uidstr(user=self._user)

cdef class PkgUserIter(object):
    """
    Package user iterator object.

    Provides a mechanism for iterating over the users provided/needed by a package.

    """
    cdef c_pkg.pkg *_pkg
    cdef c_pkg.pkg_user *_user

    def __cinit__(self):
        """
        Initialize the user iterator.

        """
        self._user = NULL

    cdef _init(self, c_pkg.pkg *pkg):
        """
        Set the C pointer of the package object.

        """
        self._pkg = pkg

    def __dealloc__(self):
        """
        Release any previously allocated resources.

        """
        pass

    def __iter__(self):
        return self

    def __len__(self):
        """
        Return the number of users a package provides/needs.

        """
        cdef unsigned i = 0

        for u in self:
            i += 1

        return i

    def __contains__(self, name):
        """
        Test if a user is provided/needed by a package.

        Returns:
            True if the user exists, False otherwise

        """
        for u in self:
            if u.name() == name:
                return True

        return False

    def __next__(self):
        """
        Return the next package user from the iterator.

        Returns:
            PkgUser() object

        Raises:
            StopIteration

        """
        result = c_pkg.pkg_users(pkg=self._pkg, user=&self._user)

        if result != c_pkg.EPKG_OK:
            raise StopIteration

        pkg_user_obj = PkgUser()
        pkg_user_obj._init(self._user)

        return pkg_user_obj
            
