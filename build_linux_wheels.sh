#!/usr/bin/env bash
cd /io
/opt/python/cp36-cp36m/bin/python -m pip install -r build_requirements.txt
/opt/python/cp36-cp36m/bin/python setup.py bdist_wheel
/opt/python/cp37-cp37m/bin/python -m pip install -r build_requirements.txt
/opt/python/cp37-cp37m/bin/python setup.py bdist_wheel

