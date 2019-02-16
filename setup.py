import numpy
from Cython.Build import cythonize
from Cython.Distutils import build_ext
from setuptools import setup, Extension


EXTENSIONS = cythonize(
    [
        Extension('leafy.data_structure', ['leafy/data_structure.pyx'],
                  include_dirs=[numpy.get_include()]),
        Extension('leafy.cgraph', ['leafy/cgraph.pyx'],
                  include_dirs=[numpy.get_include()]),
        Extension('leafy.search', ['leafy/search.pyx'],
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
