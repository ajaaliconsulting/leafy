import numpy
from Cython.Build import cythonize
from Cython.Distutils import build_ext
from setuptools import setup, Extension

ext_1 = Extension(
    'cgraph', ['cgraph.pyx'],
    include_dirs=[numpy.get_include()],
)

ext_2 = Extension(
    'dfs', ['dfs.pyx'],
    include_dirs=[numpy.get_include()],
)

EXTENSIONS = cythonize([ext_1, ext_2], annotate=True)

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
