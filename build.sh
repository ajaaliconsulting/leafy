#!/usr/bin/env bash

python3.7 -m venv venv_b37
source venv_b37/bin/activate
python -m pip install -r build_requirements.txt
python setup.py bdist_wheel
rm -r ./venv_b37

python3.8 -m venv venv_b38
source venv_b38/bin/activate
python -m pip install -r build_requirements.txt
python setup.py bdist_wheel
rm -r ./venv_b38

docker run -it -v `pwd`:/io quay.io/pypa/manylinux1_x86_64 /io/build_linux_wheels.sh
