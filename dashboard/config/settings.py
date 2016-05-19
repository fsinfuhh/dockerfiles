import os
ROOT_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))

# Django settings for mafiasi project.

DEBUG = True
TEMPLATE_DEBUG = DEBUG

ADMINS = (
    # ('Your Name', 'your_email@example.com'),
)

MANAGERS = ADMINS

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2', # Add 'postgresql_psycopg2', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': 'mafiasi',                      # Or path to database file if using sqlite3.
        # The following settings are not used with sqlite3:
        'USER': 'mafiasi',
        'PASSWORD': 'foobar',
        'HOST': '127.0.0.1',                      # Empty for localhost through domain sockets or '127.0.0.1' for localhost through TCP.
        'PORT': '',                      # Set to empty string for default.
    },
    'jabber': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2', # Add 'postgresql_psycopg2', 'mysql', 'sqlite3' or 'oracle'.
        'NAME': 'ejabberd',                      # Or path to database file if using sqlite3.
        # The following settings are not used with sqlite3:
        'USER': 'ejabberd',
        'PASSWORD': 'foobar',
        'HOST': '127.0.0.1',                      # Empty for localhost through domain sockets or '127.0.0.1' for localhost through TCP.
        'PORT': '',                      # Set to empty string for default.
    },
    'ldap': {
        'ENGINE': 'ldapdb.backends.ldap',
        'NAME': 'ldap://127.0.0.1/',
        'USER': 'cn=admin,dc=mafiasi,dc=de',
        'PASSWORD': 'foobar',
    }

}

LDAP_SERVERS = {
    'default': {
        'URI': 'ldap://127.0.0.1/',
        'BIND_DN': 'cn=admin,dc=mafiasi,dc=de',
        'BIND_PASSWORD': 'foobar',
    }
}

# Hosts/domain names that are valid for this site; required if DEBUG is False
# See https://docs.djangoproject.com/en/1.5/ref/settings/#allowed-hosts
ALLOWED_HOSTS = ['mafiasi.de', '134.100.9.222:11371', '134.100.9.222']

# Local time zone for this installation. Choices can be found here:
# http://en.wikipedia.org/wiki/List_of_tz_zones_by_name
# although not all choices may be available on all operating systems.
# In a Windows environment this must be set to your system time zone.
TIME_ZONE = 'Europe/Berlin'

# Language code for this installation. All choices can be found here:
# http://www.i18nguy.com/unicode/language-identifiers.html
LANGUAGE_CODE = 'de-de'

SITE_ID = 1

# If you set this to False, Django will make some optimizations so as not
# to load the internationalization machinery.
USE_I18N = True

# If you set this to False, Django will not format dates, numbers and
# calendars according to the current locale.
USE_L10N = True

# If you set this to False, Django will not use timezone-aware datetimes.
USE_TZ = True

# Absolute filesystem path to the directory that will hold user-uploaded files.
# Example: "/var/www/example.com/media/"
MEDIA_ROOT = os.path.join(ROOT_DIR, '_media')

# URL that handles the media served from MEDIA_ROOT. Make sure to use a
# trailing slash.
# Examples: "http://example.com/media/", "http://media.example.com/"
MEDIA_URL = '/media/'

# Absolute path to the directory static files should be collected to.
# Don't put anything in this directory yourself; store your static files
# in apps' "static/" subdirectories and in STATICFILES_DIRS.
# Example: "/var/www/example.com/static/"
STATIC_ROOT = os.path.join(ROOT_DIR, '_static')

# URL prefix for static files.
# Example: "http://example.com/static/", "http://static.example.com/"
STATIC_URL = '/static/'

# Additional locations of static files
STATICFILES_DIRS = (
    # Put strings here, like "/home/html/static" or "C:/www/django/static".
    # Always use forward slashes, even on Windows.
    # Don't forget to use absolute paths, not relative paths.
)

# List of finder classes that know how to find static files in
# various locations.
STATICFILES_FINDERS = (
    'django.contrib.staticfiles.finders.FileSystemFinder',
    'django.contrib.staticfiles.finders.AppDirectoriesFinder',
#    'django.contrib.staticfiles.finders.DefaultStorageFinder',
)

# Make this unique, and don't share it with anybody.
SECRET_KEY = 'THIS IS JUST FOR DEVELOPMENT MODE'

# List of callables that know how to import templates from various sources.
TEMPLATE_LOADERS = (
    'django.template.loaders.filesystem.Loader',
    'django.template.loaders.app_directories.Loader',
#     'django.template.loaders.eggs.Loader',
)

MIDDLEWARE_CLASSES = (
    'django.middleware.common.CommonMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.locale.LocaleMiddleware',
    # Uncomment the next line for simple clickjacking protection:
    # 'django.middleware.clickjacking.XFrameOptionsMiddleware',
)

ROOT_URLCONF = 'mafiasi.urls'

# Python dotted path to the WSGI application used by Django's runserver.
WSGI_APPLICATION = 'mafiasi.wsgi.application'

TEMPLATE_DIRS = (
    # Put strings here, like "/home/html/django_templates" or "C:/www/django/templates".
    # Always use forward slashes, even on Windows.
    # Don't forget to use absolute paths, not relative paths.
)

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.admindocs',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.messages',
    'django.contrib.sessions',
    'django.contrib.sites',
    'django.contrib.staticfiles',
    'django.contrib.humanize',
    'mafiasi.base',
    'mafiasi.dashboard',
    'mafiasi.discourse',
    'mafiasi.etherpad',
    'mafiasi.gprot',
    'mafiasi.groups',
    'mafiasi.jabber',
    'mafiasi.mumble',
    'mafiasi.pks',
    'mafiasi.registration',
    'mafiasi.teaching',
	'mafiasi.owncloud',
    'raven.contrib.django.raven_compat',
    'widget_tweaks',
)

SESSION_SERIALIZER = 'django.contrib.sessions.serializers.JSONSerializer'

TEST_RUNNER = 'django.test.runner.DiscoverRunner'

AUTH_USER_MODEL = 'base.Mafiasi'
EMAIL_DOMAIN = u'informatik.uni-hamburg.de'
PRIMARY_DOMAIN = u'informatik.uni-hamburg.de'
REGISTER_DOMAINS =  [u'informatik.uni-hamburg.de', u'physnet.uni-hamburg.de']
REGISTER_DOMAIN_MAPPING = {
    u'physnet.uni-hamburg.de': 'physnet',
}
JABBER_DOMAIN = u'jabber.mafiasi.de'
JABBER_CERT_FINGERPRINT = u'04:A9:9C:D7:D8:CB:27:01:F7:29:D4:57:53:A2:B8:AA:6C:71:36:BB'
MUMBLE_SERVER = {
    'address': u'mumble.mafiasi.de',
    'port': 64738,
    'fingerprint': u'EA:51:49:D1:91:63:89:E7:78:29:C9:52:C9:85:C6:8D:AD:C4:2A:3D'
}
LOGIN_URL = '/login'
LOGIN_REDIRECT_URL = '/dashboard/'
DATABASE_ROUTERS = ['mafiasi.jabber.dbrouter.JabberRouter', 'ldapdb.router.Router']
SERVICE_LINKS = {
    'etherpad': 'https://ep.mafiasi.de/',
    'wiki': 'https://wiki.mafiasi.de/',
    'dudel': 'https://dudel.mafiasi.de/',
    'gprot': 'https://www2.informatik.uni-hamburg.de/Fachschaft/gprot/',
    'planet': 'https://planet.mafiasi.de/',
    'fb18': 'https://fb18.de/',
    'redmine': 'https://redmine.mafiasi.de/',
	'discourse': 'https://discourse.mafiasi.de/',
	'sogo': 'https://sogo.mafiasi.de/',
}
IMPRINT_URL = 'https://wiki.mafiasi.de/Fachschaft_Informatik:Impressum'
TEAM_EMAIL = u'ag-server@informatik.uni-hamburg.de'
WIKI_URL = 'https://www2.informatik.uni-hamburg.de/Fachschaft/wiki/'
GPG_KEYRING='~mafiasi/signing-party-fun/tmp/keyring'

from django.contrib.messages import constants as message_constants
MESSAGE_TAGS = {
    message_constants.DEBUG: 'alert-info',
    message_constants.INFO: 'alert-info',
    message_constants.SUCCESS: 'alert-success',
    message_constants.WARNING: 'alert-warning',
    message_constants.ERROR: 'alert-danger'
}

LOCALE_PATHS = (os.path.join(ROOT_DIR, 'locale'), )

LANGUAGES = (
    ('de', 'Deutsch'),
    ('en', 'English'),
)

# A sample logging configuration. The only tangible logging
# performed by this configuration is to send an email to
# the site admins on every HTTP 500 error when DEBUG=False.
# See http://docs.djangoproject.com/en/dev/topics/logging for
# more details on how to customize your logging configuration.
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'filters': {
        'require_debug_false': {
            '()': 'django.utils.log.RequireDebugFalse'
        }
    },
    'handlers': {
#        'mail_admins': {
#            'level': 'ERROR',
#            'filters': ['require_debug_false'],
#            'class': 'django.utils.log.AdminEmailHandler'
#        }
    },
    'loggers': {
        'django.request': {
            'handlers': [], # 'mail_admins'
            'level': 'ERROR',
            'propagate': True,
        },
    }
}

SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True

EMAIL_HOST = 'mailhost.informatik.uni-hamburg.de'
SERVER_EMAIL = 'Mafiasi.de server-ag@informatik.uni-hamburg.de'
DEFAULT_FROM_EMAIL = u'Mafiasi.de <ag-server@informatik.uni-hamburg.de>'
SERVER_EMAIL = DEFAULT_FROM_EMAIL
EMAIL_SUBJECT_PREFIX = u'[mafiasi.de] '

ROOT_DN = 'dc=mafiasi,dc=de'
CALDAV_BASE_URL = 'http://localhost:5232/dav/'
CALDAV_DISPLAY_URL = 'https://mafiasi.de/dav/'
HKP_URL = 'hkp://mafiasi.de'

import ldap
from django_auth_ldap.config import LDAPSearch

AUTHENTICATION_BACKENDS = (
    'django_auth_ldap.backend.LDAPBackend',
    'django.contrib.auth.backends.ModelBackend',
)
AUTH_LDAP_BIND_DN = "cn=admin,dc=mafiasi,dc=de"
AUTH_LDAP_BIND_PASSWORD = "foobar"
AUTH_LDAP_USER_SEARCH = LDAPSearch("ou=People,dc=mafiasi,dc=de",
    ldap.SCOPE_SUBTREE, "(uid=%(user)s)")
AUTH_LDAP_ALWAYS_UPDATE_USER = False

RAVEN_CONFIG = {
    'dsn': 'https://xxx:yyy@sentry.mafiasi.de/2',
}

ETHERPAD_API_KEY = 'foobar'
ETHERPAD_URL = 'https://ep.mafiasi.de'

DISCOURSE_URL = 'https://forum.mafiasi.test'
DISCOURSE_SSO_SECRET = 'secret'

GPROT_IMAGE_MAX_SIZE = 1
GPROT_PDF_MAX_SIZE = 5
MATHJAX_ROOT = '/usr/share/javascript/mathjax/'

PKS_COMMUNITY_DOMAINS = ['informatik.uni-hamburg.de', 'studium.uni-hamburg.de']

MAILINGLIST_DOMAIN = 'group.mafiasi.de'
MAILINGLIST_SERVER = ('127.0.0.1', 2522)
MAILCLOAK_DOMAIN = 'cloak.mafiasi.de'
MAILCLOAK_SERVER = ('127.0.0.1', 2523)
VALID_EMAIL_ADDRESSES = ['postmaster@mafiasi.de']
EMAIL_ADDRESSES_PASSWORD = 'changeme'
