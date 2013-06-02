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
    cdef c_pkg.pkg *_pkg
    cdef c_pkg.pkg_jobs *_jobs
    
    def __cinit__(self):
        self._pkg = NULL
        self._jobs = NULL

    cdef _init(self, c_pkg.pkg_jobs *jobs):
        self._jobs = jobs
        
    def __dealloc__(self):
        # jobs are being free()'d on a database close
        pass

    def __iter__(self):
        return self

    def __len__(self):
        return c_pkg.pkg_jobs_count(jobs=self._jobs)

    def __contains__(self, name):
        for p in self:
            if p.name() == name or p.origin() == name:
                return True

        return False

    def __next__(self):
        result = c_pkg.pkg_jobs_next(jobs=self._jobs, pkg=&self._pkg)

        if result != c_pkg.EPKG_OK:
            raise StopIteration

        pkg_obj = Pkg()
        pkg_obj._init(self._pkg)

        return pkg_obj

    cpdef apply(self):
        # TODO: Check if we have any jobs to apply at all
            
        result = c_pkg.pkg_jobs_apply(jobs=self._jobs)

        if result != c_pkg.EPKG_OK:
            raise PkgJobsApplyError, 'Cannot apply jobs'
