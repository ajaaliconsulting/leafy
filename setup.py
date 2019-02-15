from pathlib import Path

import numpy
from Cython.Build import cythonize
from Cython.Distutils import build_ext
from setuptools import setup, Extension

cython_files = [
    'leafy/data_structure.pyx',
    'leafy/cgraph.pyx',
    'leafy/dfs.pyx'
]


EXTENSIONS = cythonize(
    [
        Extension('leafy.data_structure', ['leafy/data_structure.pyx'],
                  include_dirs=[numpy.get_include()]),
        Extension('leafy.cgraph', ['leafy/cgraph.pyx'],
                  include_dirs=[numpy.get_include()]),
        Extension('leafy.dfs', ['leafy/dfs.pyx'],
                  include_dirs=[numpy.get_include()]),
    ],
    annotate=True)

if __name__ == "__main__":
    setup(install_requires=[],
          packages=['leafy'],
          zip_safe=False,
          name='leafy',
          version='0a0',
          description='Python graph algorithims',
          author='Ahmed Ali',
          author_email='ahmed@ajaali.com',
          url='https://github.com/ajaali/leafy',
          license='',
          cmdclass={"build_ext": build_ext},
          ext_modules=EXTENSIONS
          )
