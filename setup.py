#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
from setuptools import find_packages, setup

if sys.version_info < (3, 0, 0):
    raise Exception('ChEMBL web interface requires python 3')


# allow setup.py to be run from any path
os.chdir(os.path.normpath(os.path.join(os.path.abspath(__file__), os.pardir)))

# Source code root
src_dir = './src'


# Walks recursively a directory in a module and its contents and list all the files in it in the format expected by
# the package_data parameter on the setup
# TODO: it might not handle correctly cases with modules that are not root, in which case it could be used an empty
# TODO: parameter for base_package_dir and give the data_dir path relative to the source root
def add_data_dir_recursive_as_package_data(base_package_dir, data_dir, pkg_data):
    prev_files = pkg_data.get(base_package_dir, [])
    files_base_path = os.path.join(src_dir, base_package_dir, data_dir)
    for cur_dir, folders, cur_files in os.walk(files_base_path):
        cur_dir_rel = os.path.relpath(cur_dir, os.path.join(src_dir, base_package_dir))
        for file_i in cur_files:
            prev_files.append(os.path.join(cur_dir_rel, file_i))
    pkg_data[base_package_dir] = prev_files
    return pkg_data


# Includes data directories required by the Django app
package_data_desc = {}
add_data_dir_recursive_as_package_data('glados', 'db', package_data_desc)
add_data_dir_recursive_as_package_data('glados', 'locale', package_data_desc)
add_data_dir_recursive_as_package_data('glados', 'static', package_data_desc)
add_data_dir_recursive_as_package_data('glados', 'static_root', package_data_desc)
add_data_dir_recursive_as_package_data('glados', 'templates', package_data_desc)

requirements_data = []
with open('./requirements.txt', 'r') as req_f:
    for line in iter(req_f):
        line = line.strip()
        if line != "":
            requirements_data.append(line)

print('REQUIREMENTS:')
print(requirements_data)

setup(
    name='glados',
    version='0.1',
    author='David Mendez, Juan F. Mosquera',
    author_email='dmendez@ebi.ac.uk, jfmosquera@ebi.ac.uk',
    description='Python package providing new chembl web interface.',
    license='Apache Software License',
    package_dir={'': src_dir},
    packages=find_packages(src_dir),
    long_description=open('README.md').read(),
    install_requires=requirements_data,
    package_data=package_data_desc,
    include_package_data=True,
    classifiers=['Development Status :: 2 - Pre-Alpha',
                 'Environment :: Web Environment',
                 'Framework :: Django',
                 'Intended Audience :: Science/Research',
                 'License :: OSI Approved :: Apache Software License',
                 'Operating System :: POSIX :: Linux',
                 'Programming Language :: Python :: 3.5',
                 'Topic :: Scientific/Engineering :: Chemistry'],
    test_suite='glados.tests.run_tests',
    zip_safe=False,
)
