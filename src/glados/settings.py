"""
Django settings for mysite project.

Generated by 'django-admin startproject' using Django 1.9.2.

For more information on this file, see
https://docs.djangoproject.com/en/1.9/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.9/ref/settings/
"""

import os
import glados
from django.utils.translation import ugettext_lazy as _
import logging
import yaml
from pymongo.read_preferences import ReadPreference


class GladosSettingsError(Exception):
    """Base class for exceptions in GLaDOS configuration."""
    pass


class RunEnvs(object):
    DEV = 'DEV'
    TRAVIS = 'TRAVIS'
    TEST = 'TEST'
    PROD = 'PROD'

# ----------------------------------------------------------------------------------------------------------------------
# Read config file
# ----------------------------------------------------------------------------------------------------------------------

custom_config_file_path = os.getenv('CONFIG_FILE_PATH')
if custom_config_file_path is not None:
    CONFIG_FILE_PATH = custom_config_file_path
else:
    CONFIG_FILE_PATH = os.getenv("HOME") + '/.chembl-glados/config.yml'
print('CONFIG_FILE_PATH: ', CONFIG_FILE_PATH)
run_config = yaml.load(open(CONFIG_FILE_PATH, 'r'))
print('run_config: ', run_config)

RUN_ENV = run_config['run_env']
if RUN_ENV not in [RunEnvs.DEV, RunEnvs.TRAVIS, RunEnvs.TEST, RunEnvs.PROD]:
    raise GladosSettingsError("Run environment {} is not supported.".format(RUN_ENV))

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = RUN_ENV in [RunEnvs.DEV, RunEnvs.TRAVIS]
print('DEBUG: ', DEBUG)

# Build paths inside the project like this: os.path.join(GLADOS_ROOT, ...)
GLADOS_ROOT = os.path.dirname(os.path.abspath(glados.__file__))
DYNAMIC_DOWNLOADS_DIR = os.path.join(GLADOS_ROOT, 'dynamic-downloads')
print('DYNAMIC_DOWNLOADS_DIR: ', DYNAMIC_DOWNLOADS_DIR)

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.9/howto/deployment/checklist/

BASE_DIR = os.path.dirname(os.path.dirname(__file__))
# ----------------------------------------------------------------------------------------------------------------------
# SERVER BASE PATH
# ----------------------------------------------------------------------------------------------------------------------


# For usage behind proxies eg: 'chembl/beta/', you don't need to care about this in DEV mode
SERVER_BASE_PATH = '' if os.getenv('SERVER_BASE_PATH') is None else os.getenv('SERVER_BASE_PATH') + '/'
print('SERVER_BASE_PATH: ', SERVER_BASE_PATH)

# ----------------------------------------------------------------------------------------------------------------------
# Admin user
# ----------------------------------------------------------------------------------------------------------------------
ADMIN_USER_CONFIG = run_config.get('admin_user')

# ----------------------------------------------------------------------------------------------------------------------
# SECURITY WARNING: keep the secret key used in production secret!
# ----------------------------------------------------------------------------------------------------------------------
SECRET_KEY = run_config.get('server_secret_key',
                            'Cake and grief counseling will be available at the conclusion of the test.')

# ----------------------------------------------------------------------------------------------------------------------
# Twitter
# ----------------------------------------------------------------------------------------------------------------------
TWITTER_ENABLED = run_config.get('enable_twitter', False)

if TWITTER_ENABLED:

    twitter_secrets = run_config.get('twitter_secrets')
    if twitter_secrets is None:
        raise GladosSettingsError("You must provide the twitter secrets ")

    TWITTER_ACCESS_TOKEN = twitter_secrets.get('twitter_access_token', '')
    TWITTER_ACCESS_TOKEN_SECRET = twitter_secrets.get('twitter_access_token_secret', '')
    TWITTER_CONSUMER_KEY = twitter_secrets.get('twitter_access_consumer_key', '')
    TWITTER_CONSUMER_SECRET = twitter_secrets.get('twitter_access_consumer_secret', '')

# ----------------------------------------------------------------------------------------------------------------------
# Blogger
# ----------------------------------------------------------------------------------------------------------------------
BLOGGER_ENABLED = run_config.get('enable_blogger', False)
if BLOGGER_ENABLED:
    blogger_secrets = run_config.get('blogger_secrets')
    if blogger_secrets is None:
        raise GladosSettingsError("You must provide the blogger secrets ")

    BLOGGER_KEY = blogger_secrets.get('blogger_key', '')


# ----------------------------------------------------------------------------------------------------------------------
# ElasticSearch
# ----------------------------------------------------------------------------------------------------------------------
elasticsearch_config = run_config.get('elasticsearch')
print('elasticsearch_config: ', elasticsearch_config)
if elasticsearch_config is None:
    raise GladosSettingsError("You must provide the elasticsearch configuration")
else:
    ELASTICSEARCH_HOST = elasticsearch_config.get('host')

    if RUN_ENV == RunEnvs.TRAVIS:
        print('is running in Travis!')
        ELASTICSEARCH_USERNAME = os.getenv('ELASTICSEARCH_USERNAME')
        ELASTICSEARCH_PASSWORD = os.getenv('ELASTICSEARCH_PASSWORD')
    else:
        ELASTICSEARCH_USERNAME = elasticsearch_config.get('username')
        ELASTICSEARCH_PASSWORD = elasticsearch_config.get('password')

    print('ELASTICSEARCH_HOST: ', ELASTICSEARCH_HOST)
    print('ELASTICSEARCH_USERNAME: ', ELASTICSEARCH_USERNAME)
    print('ELASTICSEARCH_PASSWORD: ', ELASTICSEARCH_PASSWORD)


ALLOWED_HOSTS = ['*']

# Application definition

INSTALLED_APPS = [
  'django.contrib.admin',
  'django.contrib.auth',
  'django.contrib.contenttypes',
  'django.contrib.sessions',
  'django.contrib.messages',
  'django.contrib.staticfiles',
  'corsheaders',
  'glados',
  'compressor',
  'twitter',
  'django_rq'
]

MIDDLEWARE_CLASSES = [
  'corsheaders.middleware.CorsMiddleware',    
  'django.middleware.security.SecurityMiddleware',
  'django.contrib.sessions.middleware.SessionMiddleware',
  'django.middleware.locale.LocaleMiddleware',
  'django.middleware.common.CommonMiddleware',
  'django.middleware.csrf.CsrfViewMiddleware',
  'django.contrib.auth.middleware.AuthenticationMiddleware',
  'django.contrib.auth.middleware.SessionAuthenticationMiddleware',
  'django.contrib.messages.middleware.MessageMiddleware',
  'django.middleware.clickjacking.XFrameOptionsMiddleware',
  'whitenoise.middleware.WhiteNoiseMiddleware'
]

CORS_URLS_REGEX = r'^/api/.*$'
CORS_ORIGIN_ALLOW_ALL = True

ROOT_URLCONF = 'glados.urls'

TEMPLATES = [
  {
    'BACKEND': 'django.template.backends.django.DjangoTemplates',
    'DIRS': [os.path.join(GLADOS_ROOT, 'templates/'),],
    'APP_DIRS': True,
    'OPTIONS': {
      'context_processors': [
        'django.template.context_processors.debug',
        'django.template.context_processors.request',
        'django.contrib.auth.context_processors.auth',
        'django.contrib.messages.context_processors.messages',
        'glados.settings_context.glados_settings_context_processor',
      ],
      'debug': DEBUG,
    },
  },
]

# ----------------------------------------------------------------------------------------------------------------------
# Database
# https://docs.djangoproject.com/en/1.9/ref/settings/#databases
# ----------------------------------------------------------------------------------------------------------------------

DATABASES = {
  'default': {
    'ENGINE': 'django.db.backends.sqlite3',
    'NAME': os.path.join(GLADOS_ROOT, 'db/db.sqlite3')
  }
}

if RUN_ENV != RunEnvs.TRAVIS:

    DATABASES['oradb'] = {
        'ENGINE': 'django.db.backends.oracle',
        'NAME': 'oradb/xe',
        'USER': 'hr',
        'PASSWORD': 'hr'
    }

    DATABASE_ROUTERS = ['glados.db.APIDatabaseRouter.APIDatabaseRouter']
# ----------------------------------------------------------------------------------------------------------------------
# Django RQ
# https://github.com/rq/django-rq
# ----------------------------------------------------------------------------------------------------------------------
RQ_QUEUES = {
    'default': {
        'HOST': 'localhost',
        'PORT': 6379,
        'DB': 0,
        'DEFAULT_TIMEOUT': 3600,
    },
}

# ----------------------------------------------------------------------------------------------------------------------
# Password validation
# https://docs.djangoproject.com/en/1.9/ref/settings/#auth-password-validators
# ----------------------------------------------------------------------------------------------------------------------

AUTH_PASSWORD_VALIDATORS = [
  {
    'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
  },
  {
    'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
  },
  {
    'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
  },
  {
    'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
  },
]

# ----------------------------------------------------------------------------------------------------------------------
# Internationalization
# https://docs.djangoproject.com/en/1.9/topics/i18n/
# ----------------------------------------------------------------------------------------------------------------------

LANGUAGE_CODE = 'en'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_L10N = True
USE_TZ = True
LANGUAGES = [
    ('en', _('English')),
]
LOCALE_PATHS = [
    os.path.join(GLADOS_ROOT, 'locale'),
]

# ----------------------------------------------------------------------------------------------------------------------
# STATIC FILES (CSS, JavaScript, Images) and URL's
# https://docs.djangoproject.com/en/1.9/howto/static-files/
# ----------------------------------------------------------------------------------------------------------------------

USE_X_FORWARDED_HOST = True

STATIC_URL = '/{0}static/'.format(SERVER_BASE_PATH)

STATICFILES_DIRS = (
  os.path.join(GLADOS_ROOT, 'static/'),
)

STATIC_ROOT = os.path.join(GLADOS_ROOT, 'static_root')

STATICFILES_FINDERS = (
    'django.contrib.staticfiles.finders.FileSystemFinder',
    'compressor.finders.CompressorFinder',
)

WATCH_AND_UPDATE_STATIC_COMPILED_FILES = RUN_ENV in [RunEnvs.DEV, RunEnvs.TRAVIS]
print('WATCH_AND_UPDATE_STATIC_COMPILED_FILES: ', WATCH_AND_UPDATE_STATIC_COMPILED_FILES)

# ----------------------------------------------------------------------------------------------------------------------
# File Compression (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.9/howto/static-files/
# ----------------------------------------------------------------------------------------------------------------------

COMPRESS_ENABLED = RUN_ENV in [RunEnvs.TEST, RunEnvs.PROD]
print('COMPRESS_ENABLED: ', COMPRESS_ENABLED)

if COMPRESS_ENABLED:
    COMPRESS_OFFLINE = True

    COMPRESS_CSS_FILTERS = ['compressor.filters.css_default.CssAbsoluteFilter',
                            'compressor.filters.cssmin.CSSMinFilter']
    COMPRESS_JS_FILTERS = ['compressor.filters.jsmin.JSMinFilter']
    COMPRESS_URL = STATIC_URL
    COMPRESS_ROOT = STATIC_ROOT
    #COMPRESS_CLOSURE_COMPILER_BINARY = 'java -jar '+ os.path.join(BASE_DIR,
    #'external_tools/closure_compiler/closure-compiler-v20180610.jar')

# ----------------------------------------------------------------------------------------------------------------------
# HTTPS SSL PROXY HEADER
# ----------------------------------------------------------------------------------------------------------------------

SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')

# ----------------------------------------------------------------------------------------------------------------------
# Cache
# ----------------------------------------------------------------------------------------------------------------------
ENABLE_MONGO_DB_CACHE = run_config.get('enable_mongo_db_cache', False)
print('ENABLE_MONGO_DB_CACHE: ', ENABLE_MONGO_DB_CACHE)

if not ENABLE_MONGO_DB_CACHE:

    CACHES = {
        'default': {
            'BACKEND': 'django.core.cache.backends.memcached.MemcachedCache',
            'LOCATION': '127.0.0.1:11211',
        }
    }
else:

    mongo_db_cache_config = run_config.get('mongo_db_cache_config')

    if mongo_db_cache_config is None:
        raise GladosSettingsError('You must provide a mongdo db cache configuration!')

    mongo_db_cache_config['OPTIONS']['READ_PREFERENCE'] = ReadPreference.SECONDARY_PREFERRED

    CACHES = {
        'default': mongo_db_cache_config
    }

    print('CACHES: ', CACHES)



# ----------------------------------------------------------------------------------------------------------------------
# Logging
# ----------------------------------------------------------------------------------------------------------------------


LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'glados': {
            'class': 'glados.logging_helper.MultiLineFormatter',
            'format': '%(asctime)s %(levelname)-8s %(message)s',
            'datefmt': '%Y-%m-%d %H:%M:%S'
        }
    },
    'handlers': {
        'console': {
            'level': logging.DEBUG,
            'class': 'glados.logging_helper.ColoredConsoleHandler',
            'formatter': 'glados',
        },
    },
    'loggers': {
        'django': {
            'handlers': ['console'],
            'level': os.getenv('DJANGO_LOG_LEVEL', 'INFO'),
        },
        'elasticsearch': {
            'level': logging.CRITICAL
        },
        'glados.static_files_compiler': {
            'handlers': ['console'],
            'level': logging.DEBUG if WATCH_AND_UPDATE_STATIC_COMPILED_FILES else logging.INFO,
            'propagate': True,
        },
        'glados.es_connection': {
            'handlers': ['console'],
            'level': logging.INFO,
            'propagate': True,
        },
    },
}
