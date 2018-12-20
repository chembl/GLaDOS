from django.conf import settings
from glados.settings import GladosSettingsError


def generate_admin_user():

    admin_user_config = settings.ADMIN_USER_CONFIG
    if admin_user_config is None:
        raise GladosSettingsError('You must provide a configuration for the admin user in the config file!')

    username = admin_user_config.get('username')
    if username is None:
        raise GladosSettingsError('You must provide a username!')

    email = admin_user_config.get('email')
    if email is None:
        raise GladosSettingsError('You must provide an email!')

    password = admin_user_config.get('password')
    if password is None:
        raise GladosSettingsError('You must provide a password!')

    import django
    django.setup()

    from django.contrib.auth import get_user_model
    User = get_user_model()

    #always delete previous user and overwrite it
    try:
        u = User.objects.get(username=username)
        u.delete()
    except User.DoesNotExist:
        pass

    User.objects.create_superuser(username, email, password)
    print('Username {} with email {} created.'.format(username, email))
