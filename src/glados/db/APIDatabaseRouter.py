class APIDatabaseRouter:

    def db_for_write(self, model, **hints):
        """Send all write operations on Glados app models to `default`."""
        if model._meta.app_label == 'glados':
            return 'default'
        return None

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        """
        Make sure only glados app can migrate
        """
        if app_label == 'glados':
            return db == 'default'
        return None
