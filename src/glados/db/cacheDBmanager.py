from pymongo import MongoClient

class MongoConnection(object):

    def __init__(self):
        client = MongoClient('mongodb', 27017)
        self.db = client['django_cache']
    
    def get_collection(self, name):
        self.collection =  self.db['sssapicache']
