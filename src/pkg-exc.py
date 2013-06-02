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

class PkgAlreadyInitialized(Exception):
    """
    Indicates that the library has already been initialized.

    Raised if a consequent initialization to the library is requested,
    while it has already been initiliazed.

    """
    pass

class PkgNotInitialized(Exception):
    """
    Indicates that the library is not initiliazed for use.

    Raised when accessing library functions, but
    the library has not been initialized or failed to do so.

    """
    pass

class PkgJobsAddError(Exception):
    """
    Error occurred while trying to add packages to a jobs object.

    """
    pass
    
class PkgJobsSolveError(Exception):
    """
    Error occurred while trying to solve package jobs.

    """
    pass
    
class PkgJobsApplyError(Exception):
    """
    Error occurred while trying to apply package jobs.

    """
    pass

class PkgAccessError(Exception):
    """
    Error indicating a permissions issue.

    Raised when trying to access certain functionallity of the
    library, but lack of permissions to do so has been detected.

    """
    pass

class PkgTypeError(Exception):
    """
    Error indicating access to attribute which is not specific for the package.

    Raised when requesting an attribute of a package for which the package type
    is not applicable, e.g. requesting the package repository for a local package file.

    """
    pass

