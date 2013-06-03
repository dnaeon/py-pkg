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

cdef class PkgDep(object):
    """
    Package dependency object.

    Provides methods for accessing various package dependency attributes.

    """
    cdef c_pkg.pkg_dep *_dep

    def __cinit__(self):
        """
        Initializes a new package dependency object.

        """
        self._dep = NULL

    cdef _init(self, c_pkg.pkg_dep *dep):
        """
        Set the C dependency pointer.

        Sets the C pointer representing a package dependency.

        """
        self._dep = dep

    def __dealloc__(self):
        """
        Deallocates any previous allocated resources.

        Releases any previous allocated memory by the package dependency.

        """
        pass

    def __str__(self):
        """
        String representation of a package dependency object.

        Returns:
            A '<name>-<version>' string representing the package dependency.

        """
        return '%s-%s' % (self.name(), self.version())
        
    cpdef name(self):
        """
        Retrieve the package dependency name.
        
        Retrieves and returns the package dependency name, e.g. 'libevent'.
        
        Returns:
            A string object representing the package dependency name
        
        """
        return c_pkg.pkg_dep_get(dep=self._dep, attr=c_pkg.PKG_DEP_NAME)

    cpdef origin(self):
        """
        Retrieve the package dependency origin.
        
        Retrieves and returns the package dependency origin.
        
        Returns:
            A string object representing the package dependency origin
        
        """
        return c_pkg.pkg_dep_get(dep=self._dep, attr=c_pkg.PKG_DEP_ORIGIN)

    cpdef version(self):
        """
        Retrieve the package dependency version.

        Retrieves and returns the package dependency version, e.g. 'x.y.z-b1'.
        
        Returns:
            A string object representing the package dependency version
        
        """
        return c_pkg.pkg_dep_get(dep=self._dep, attr=c_pkg.PKG_DEP_VERSION)

cdef class PkgDepIter(object):
    """
    Package dependency iterator object.

    Provides methods for iterating over the dependencies of a package.

    """
    cdef c_pkg.pkg *_pkg
    cdef c_pkg.pkg_dep *_dep

    def __cinit__(self):
        """
        Intializes a new dependency object.

        """
        self._dep = NULL

    cdef _init(self, c_pkg.pkg *pkg):
        """
        Sets the C data pointer to the object.

        """
        self._pkg = pkg

    def __dealloc__(self):
        """
        Release any allocated resources.

        Releases any previous allocated resources for the package
        and it's dependencies.

        """
        pass

    def __iter__(self):
        return self

    def __len__(self):
        """
        Return the number of dependencies for a package.

        Returns:
            Integer object representing the number of dependencies for the package
        
        """
        cdef unsigned i = 0

        for d in self:
            i += 1

        return i

    def __contains__(self, name):
        """
        Test if a package contains a certain dependency.

        Arguments:
            name (str): Dependency name or origin

        Returns:
            True if the package has the dependency, False otherwise.

        """
        for d in self:
            if d.name() == name or d.origin() == name:
                return True

        return False

    def __next__(self):
        """
        Return the next package dependency.

        Iterates over the package dependencies and returns the
        next in row.

        Returns:
            PkgDep() object

        Raises:
            StopIteration

        """
        result = c_pkg.pkg_deps(pkg=self._pkg, dep=&self._dep)

        if result != c_pkg.EPKG_OK:
            raise StopIteration

        pkg_dep_obj = PkgDep()
        pkg_dep_obj._init(self._dep)

        return pkg_dep_obj

cdef class PkgRdepIter(PkgDepIter):
    """
    Package reverse dependency object.

    Extends PkgDepIter() object in order to provide
    a mechanism to iterate over the reverse dependencies of a package.

    Overrides:
        __next__()

    """
    def __next__(self):
        result = c_pkg.pkg_rdeps(pkg=self._pkg, dep=&self._dep)

        if result != c_pkg.EPKG_OK:
            raise StopIteration

        pkg_dep_obj = PkgDep()
        pkg_dep_obj._init(self._dep)

        return pkg_dep_obj
