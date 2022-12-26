from setuptools import setup, Extension

DEVELOPEMENT_MODE = False

EXTENSIONS = [
    Extension('leafy.data_structure', ['leafy/data_structure.pyx']),
    Extension('leafy.graph', ['leafy/graph.pyx']),
    Extension('leafy.search', ['leafy/search.pyx']),
    Extension('leafy.digraph', ['leafy/digraph.pyx']),
    Extension('leafy.shortest_path', ['leafy/shortest_path.pyx']),
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
    version='0.1.4',
    description='Another fast graph algorithms library',
    long_description=readme(),
    long_description_content_type='text/markdown',
    keywords="graph dag algorithm library",
    url='https://github.com/ajaaliconsulting/leafy',
    author='Ahmed Ali',
    author_email='ahmed@ajaali.com',
    license='MIT',
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: MIT License',
        "Operating System :: OS Independent",
        'Programming Language :: Cython',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        "Topic :: Scientific/Engineering :: Mathematics",
        "Topic :: Software Development :: Libraries",
    ],
    python_requires=">=3.7",
    install_requires=[],
    tests_require=[],
    packages=['leafy'],
    zip_safe=False,
    ext_modules=EXTENSIONS,
)
