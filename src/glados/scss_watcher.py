import glados
from watchdog import observers
import os
from scss import Compiler
from django.conf import settings


# Build paths inside the project like this: os.path.join(GLADOS_ROOT, ...)
print(glados.__file__)
GLADOS_ROOT = os.path.dirname(os.path.abspath(glados.__file__))
SCSS_PATH = os.path.join(GLADOS_ROOT, 'static/scss')

comp = Compiler()

result = comp.compile(os.path.join(SCSS_PATH, 'chartist.scss'))

result = comp.compile(os.path.join(SCSS_PATH, 'chembl-style.scss'))
result = comp.compile(os.path.join(SCSS_PATH, 'materialize.scss'))
#print(result)
