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

cdef class PkgJobs(object):
    """
    Package jobs object.

    Provides methods for accessing various jobs functionallity.

    """
    cdef c_pkg.pkg *_pkg
    cdef c_pkg.pkg_jobs *_jobs
    
    def __cinit__(self):
        """
        Initialize a new package jobs object.

        """
        self._pkg = NULL
        self._jobs = NULL

    cdef _init(self, c_pkg.pkg_jobs *jobs):
        """
        Set the C pointer of the jobs object.

        """
        self._jobs = jobs
        
    def __dealloc__(self):
        """
        Deallocate any previously allocated resources.
        
        Jobs are being free()'d on a database close in PkgDb()

        """
        pass

    def __iter__(self):
        return self

    def __len__(self):
        """
        Return the number of jobs we have.

        """
        return c_pkg.pkg_jobs_count(jobs=self._jobs)

    def __contains__(self, name):
        """
        Test if a package is added to the jobs.

        Returns:
            True if the jobs object contains the package, False otherwise.

        """
        for p in self:
            if p.name() == name or p.origin() == name:
                return True

        return False

    def __next__(self):
        """
        Return the next job in the queue.

        Returns:
            Pkg() object

        Raises:
            StopIteration
        
        """
        result = c_pkg.pkg_jobs_next(jobs=self._jobs, pkg=&self._pkg)

        if result != c_pkg.EPKG_OK:
            raise StopIteration

        pkg_obj = Pkg()
        pkg_obj._init(self._pkg)

        return pkg_obj

    cpdef apply(self):
        """
        Apply the jobs.

        Applies the action associated with the jobs object - install, deinstall, etc.

        Raises:
            PkgJobsApplyError

        """
        if len(self) == 0:
            return
            
        result = c_pkg.pkg_jobs_apply(jobs=self._jobs)

        if result != c_pkg.EPKG_OK:
            raise PkgJobsApplyError, 'Cannot apply jobs'
