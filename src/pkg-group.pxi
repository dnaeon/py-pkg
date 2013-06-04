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

cdef class PkgGroup(object):
    """
    Package group object.

    Provides methods for accessing attributes of package groups.

    """
    cdef c_pkg.pkg_group *_group

    def __cinit__(self):
        """
        Initialize a new package group object.

        """
        self._group = NULL

    cdef _init(self, c_pkg.pkg_group *group):
        """
        Set the C pointer of a package group object.

        """
        self._group = group

    def __dealloc__(self):
        """
        Release any previously allocated resources.

        """
        pass

    def __str__(self):
        """
        String representation of a package group object.

        Returns:
            A string object reprensenting the group name.
        
        """
        return '%s' % self.name()
        
    cpdef name(self):
        """
        Retrieve the name of the package group.

        Returns:
            A string object representing the group name.

        """
        return c_pkg.pkg_group_name(group=self._group)

    cpdef gid(self):
        """
        Retrieve the group gid.

        Returns:
            A string object reprensenting the group gid.

        """
        return c_pkg.pkg_group_gidstr(group=self._group)

cdef class PkgGroupIter(object):
    """
    Package group iterator object.

    Provides a mechanism for iterating over the package groups.

    """
    cdef c_pkg.pkg *_pkg
    cdef c_pkg.pkg_group *_group

    def __cinit__(self):
        """
        Initialize a new package group iterator.

        """
        self._group = NULL

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
        Return the number of groups a package provides/needs.

        Returns:
            Integer object representing the number of package groups.

        """
        cdef unsigned i = 0

        for d in self:
            i += 1

        return i

    def __contains__(self, name):
        """
        Test if a package contains a specific group.

        Returns:
            True if the package contains the group, False otherwise.

        """
        for g in self:
            if g.name() == name:
                return True

        return False

    def __next__(self):
        """
        Return the next package group from the iterator.

        Returns:
            PkgGroup() object

        Raises:
            StopIteration

        """
        result = c_pkg.pkg_groups(pkg=self._pkg, group=&self._group)

        if result != c_pkg.EPKG_OK:
            raise StopIteration

        pkg_group_obj = PkgGroup()
        pkg_group_obj._init(self._group)

        return pkg_group_obj
