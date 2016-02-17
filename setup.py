#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
from setuptools import find_packages, setup

if sys.version_info < (3, 0, 0):
  raise Exception('ChEMBL web interface requires python 3')

# allow setup.py to be run from any path
os.chdir(os.path.normpath(os.path.join(os.path.abspath(__file__), os.pardir)))

setup(
    name='glados',
    version='0.1',
    author='David Mendez',
    author_email='dmendez@ebi.ac.uk',
    description='Python package providing new chembl web interface.',
    license='Apache Software License',
    packages=[
        'glados',
    ],
    long_description=open('README.md').read(),
    install_requires=[
        'django>=1.9',
    ],
    include_package_data=True,
    classifiers=['Development Status :: 2 - Pre-Alpha',
                 'Environment :: Web Environment',
                 'Framework :: Django',
                 'Intended Audience :: Science/Research',
                 'License :: OSI Approved :: Apache Software License',
                 'Operating System :: POSIX :: Linux',
                 'Programming Language :: Python :: 3.5',
                 'Topic :: Scientific/Engineering :: Chemistry'],
)