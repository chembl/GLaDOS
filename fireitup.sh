#!/bin/bash
source ~/.bashrc

cd /usr/glados/ && ./manage_glados_no_install.sh runserver glados:8000

tail -f /dev/null