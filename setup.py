#!/usr/bin/env python

from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(name='pkg',
      version='0.0.1',
      description='Python wrappers for libpkg',
      author='Marin Atanasov Nikolov',
      author_email='dnaeon@gmail.com',
      license='BSD',
      cmdclass = {'build_ext': build_ext},
      ext_modules = [Extension("pkg", ["src/pkg.pyx"],
                        include_dirs=['/usr/local/include'],
                        library_dirs=['/usr/local/lib'],
                        libraries=['pkg'],
                    )]
)

