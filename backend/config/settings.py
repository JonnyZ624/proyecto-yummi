from pathlib import Path
import os

BASE_DIR = Path(__file__).resolve().parent.parent

# 🔐 IMPORTANTE: usa variable de entorno en producción
SECRET_KEY = os.environ.get('SECRET_KEY', 'django-insecure-dev-key')

# ❌ EN PRODUCCIÓN DEBE SER FALSE
DEBUG = False

# 🔥 IMPORTANTE PARA RENDER
ALLOWED_HOSTS = ['*']


# =========================
# APPS
# =========================
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    'usuarios',
    'rest_framework',
]


# =========================
# MIDDLEWARE
# =========================
MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',

    # 🔥 PARA ARCHIVOS ESTÁTICOS EN PRODUCCIÓN
    'whitenoise.middleware.WhiteNoiseMiddleware',

    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]


ROOT_URLCONF = 'config.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'config.wsgi.application'


# =========================
# BASE DE DATOS
# =========================
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}


# =========================
# PASSWORDS
# =========================
AUTH_PASSWORD_VALIDATORS = [
    {'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator'},
    {'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator'},
    {'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator'},
    {'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator'},
]


# =========================
# DRF
# =========================
REST_FRAMEWORK = {
    'DEFAULT_RENDERER_CLASSES': [
        'rest_framework.renderers.JSONRenderer',
    ]
}


# =========================
# INTERNACIONALIZACIÓN
# =========================
LANGUAGE_CODE = 'es-ec'
TIME_ZONE = 'UTC'

USE_I18N = True
USE_TZ = True


# =========================
# ARCHIVOS ESTÁTICOS
# =========================
STATIC_URL = 'static/'

STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')

# 🔥 NECESARIO PARA RENDER
STATICFILES_STORAGE = 'whitenoise.storage.CompressedManifestStaticFilesStorage'