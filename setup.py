import numpy
from Cython.Distutils import build_ext
from setuptools import setup, Extension

ext_1 = Extension('cgraph', ['cgraph.pyx'],
                  include_dirs=[numpy.get_include()])

EXTENSIONS = [ext_1]

if __name__ == "__main__":
    setup(install_requires=[],
          packages=['leafy'],
          zip_safe=False,
          name='leafy',
          version='0.a0',
          description='Python graph algorithims',
          author='Ahmed Ali',
          author_email='ahmed@ajaali.com',
          url='https://github.com/ajaali/leafy',
          license='',
          cmdclass={"build_ext": build_ext},
          ext_modules=EXTENSIONS)
