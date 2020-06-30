#!/usr/bin/env bash

# Compile wheels
for PYVER in cp36 cp37 cp38; do
    for PYBIN in /opt/python/${PYVER}*/bin; do
        "${PYBIN}/pip" install -r /io/build_requirements.txt
        "${PYBIN}/pip" wheel /io/ -w wheelhouse/
    done
done

# Bundle external shared libraries into the wheels
for whl in wheelhouse/leafy*.whl; do
    auditwheel repair "$whl" -w /io/dist/
done