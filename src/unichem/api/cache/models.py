from glados.db.cacheDBmanager import MongoConnection


class ChemCache(MongoConnection):

    def __init__(self):
        super(ChemCache, self).__init__()
        self.get_collection('chem_cache')

    def update_and_save(self, obj):
        if self.collection.find({'id': obj.id}).count():
            self.collection.update({"id": obj.id}, {'id': 123, 'name': 'test'})
        else:
            self.collection.insert_one({'id': 123, 'name': 'test'})

    def remove(self, obj):
        if self.collection.find({'id': obj.id}).count():
            self.collection.delete_one({"id": obj.id})

    def add_test(self):
        self.collection.insert_one({'id': 123, 'name': 'test'})

    def get_all(self):
        return self.collection.find()

    def isCached(self, ctab):
        if self.collection.find({'ctab': ctab}).count() > 0:
            return True

        return False

    def getChached(self, ctab):
        return self.collection.find_one({'ctab': ctab})
