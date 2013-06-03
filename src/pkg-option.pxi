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

cdef class PkgOption(object):
    """
    Package options object.

    Provides methods for accessing package options.

    """
    cdef c_pkg.pkg_option *_option

    def __cinit__(self):
        """
        Initialize a new package options object.

        """
        self._option = NULL

    cdef _init(self, c_pkg.pkg_option *option):
        """
        Set the C pointer of a package options object.

        """
        self._option = option

    def __dealloc__(self):
        """
        Release any previously allocated resources.

        """
        pass

    def __str__(self):
        """
        String representation of a package option.

        Returns:
            A string representation of a package option in the form of '<name>-<value>'

        """
        return '%s: %s' % (self.name(), self.value())
        
    cpdef name(self):
        """
        Retrieve the name of the package option.

        Retrieve and return the name of the package option.

        Returns:
            A string object representing the option name

        """
        return c_pkg.pkg_option_opt(option=self._option)

    cpdef value(self):
        """
        Retrieve the value of a package option.

        Returns:
            A string option representing the value of a package option.

        """
        
        return c_pkg.pkg_option_value(option=self._option)

cdef class PkgOptionIter(object):
    """
    Package options iterator object.
    
    Provides a mechanism for iterating over the package options.

    """
    cdef c_pkg.pkg *_pkg
    cdef c_pkg.pkg_option *_option

    def __cinit__(self):
        """
        Initialize a new options iterator object.

        """
        self._option = NULL

    cdef _init(self, c_pkg.pkg *pkg):
        """
        Set the C pointer of the package option's we iterate over.

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
        Return the number of options a package has.

        """
        cdef unsigned i = 0

        for d in self:
            i += 1

        return i

    def __contains__(self, name):
        """
        Test if a package contains an option.

        Returns:
            True if the package has the option, False otherwise.

        """
        for o in self:
            if o.name() == name:
                return True

        return False

    def __next__(self):
        """
        Return the next option of the package.

        Returns:
            PkgOption() object

        Raises:
            StopIteration
        
        """
        result = c_pkg.pkg_options(pkg=self._pkg, option=&self._option)

        if result != c_pkg.EPKG_OK:
            raise StopIteration

        pkg_option_obj = PkgOption()
        pkg_option_obj._init(self._option)

        return pkg_option_obj
            

