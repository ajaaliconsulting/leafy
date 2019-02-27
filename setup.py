import numpy
from setuptools import setup, Extension

DEVELOPEMENT_MODE = False

EXTENSIONS = [
    Extension('leafy.data_structure', ['leafy/data_structure.pyx'],
              include_dirs=[numpy.get_include()]),
    Extension('leafy.graph', ['leafy/graph.pyx'],
              include_dirs=[numpy.get_include()]),
    Extension('leafy.search', ['leafy/search.pyx'],
              include_dirs=[numpy.get_include()]),
    Extension('leafy.digraph', ['leafy/digraph.pyx'],
              include_dirs=[numpy.get_include()]),
]

setup_kwargs = {}
if DEVELOPEMENT_MODE:
    from Cython.Build import cythonize
    EXTENSIONS = cythonize(EXTENSIONS, annotate=True)


def readme():
    with open('README.md') as f:
        return f.read()


setup(
    name='leafy',
    version='0.1.0a2',
    description='Another fast graph algorithms library',
    long_description=readme(),
    long_description_content_type='text/markdown',
    keywords="graph dag algorithm library",
    url='https://github.com/ajaali/leafy',
    author='Ahmed Ali',
    author_email='ahmed@ajaali.com',
    license='MIT',
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        "Operating System :: OS Independent",
        'Programming Language :: Cython',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        "Topic :: Scientific/Engineering :: Mathematics",
        "Topic :: Software Development :: Libraries",
    ],
    python_requires=">=3.6",
    install_requires=[
        'numpy>=1.16.1',
        'cython>=0.29.4',
    ],
    tests_require=[
        'pytest>=4.2.1',
        'tabulate>=0.8.2',
    ],
    packages=['leafy'],
    zip_safe=False,
    ext_modules=EXTENSIONS,
)
