


class APIDatabaseRouter:

    def db_for_write(self, model, **hints):
        """Send all write operations on Example app models to `example_db`."""
        if model._meta.app_label == 'glados':
            return 'default'
        return None

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        """
        Make sure the auth app only appears in the 'auth_db'
        database.
        """
        if app_label == 'glados':
            return db == 'default'
        return None