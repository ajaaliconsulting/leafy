from pathlib import Path

import numpy
from Cython.Build import cythonize
from Cython.Distutils import build_ext
from setuptools import setup, Extension

cython_files = [
    'data_structure.pyx',
    'cgraph.pyx',
    'dfs.pyx'
]

EXTENSIONS = cythonize(
    [
        Extension(
            Path(m).stem, [m],
            include_dirs=[numpy.get_include()],
        ) for m in cython_files
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
