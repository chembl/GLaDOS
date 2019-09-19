# -*- coding: utf-8 -*-
# Author Karol Sikora <karol.sikora@laboratorium.ee>, (c) 2012
# Author Michal Nowotka <mmmnow@gmail.com>, (c) 2013-2014
# Author David Mendez <nclopezo@gmail.com>, (c) 2018

try:
    import cPickle as pickle
except ImportError:
    import pickle
import base64
import pymongo
from bson import Binary
from datetime import datetime, timedelta
from django.core.cache.backends.base import BaseCache
import zlib
import logging
import datetime
try:
    from urllib import urlencode
except ImportError:
    from urllib.parse import urlencode

# ----------------------------------------------------------------------------------------------------------------------

MAX_SIZE = 16000000

# ----------------------------------------------------------------------------------------------------------------------


class MongoDBCache(BaseCache):

    def __init__(self, location, params):
        BaseCache.__init__(self, params)
        self.location = location
        options = params.get('OPTIONS', {})
        self._host = options.get('HOST', 'localhost')
        self._port = options.get('PORT', 27017)
        self._database = options.get('DATABASE', 'django_glados_cache')
        self._auth_database = options.get('AUTH_DATABASE', self._database)
        self._rshosts = options.get('RSHOSTS')
        self._rsname = options.get('RSNAME')
        self._user = options.get('USER', None)
        self._password = options.get('PASSWORD', None)
        self._server_selection_timeout_ms = options.get('SERVER_SELECTION_TIMEOUT_MS', 30000)
        self._socket_timeout_ms = options.get('SOCKET_TIMEOUT_MS', None)
        self._connect_timeout_ms = options.get('CONNECT_TIMEOUT_MS', 20000)
        self._max_time_ms = options.get('MAX_TIME_MS', 2000)
        self._compression = options.get('COMPRESSION', True)
        self.compression_level = options.get('COMPRESSION_LEVEL', 0)
        self._tag_sets = options.get('TAG_SETS', None)
        self._read_preference = options.get("READ_PREFERENCE")
        self._collection = location
        self.log = logging.getLogger(__name__)

# ----------------------------------------------------------------------------------------------------------------------

    def add(self, key, value, timeout=None, version=None):
        key = self.make_key(key, version)
        self.validate_key(key)
        self._base_set('add', key, value, timeout)

# ----------------------------------------------------------------------------------------------------------------------

    def set(self, key, value, timeout=None, version=None):
        previous_value = self.get(key)
        key = self.make_key(key, version)
        self.validate_key(key)
        self._base_set('set', key, value, timeout)

# ----------------------------------------------------------------------------------------------------------------------

    def validate_key(self, key):
        return

# ----------------------------------------------------------------------------------------------------------------------

    def _base_set(self, mode, key, value, timeout=None):
        expiration_time = datetime.datetime.now() + datetime.timedelta(seconds=timeout)
        coll = self._get_collection()
        encoded = self._encode(value)
        document_size = len(encoded)
        data = coll.find_one({'_id': key}, max_time_ms=self._max_time_ms)
        if data and (mode == 'set' or mode == 'add'):
            pass
        if not self._compression or document_size <= MAX_SIZE:
            coll.replace_one({'_id': key}, {'_id':key, 'data':encoded, 'expires':expiration_time}, True)
        else:
            chunk_keys = []
            chunks = []
            for i in range(0, document_size, MAX_SIZE):
                chunk = encoded[i:i + MAX_SIZE]
                aux_key = self.make_key(chunk)
                chunk.append({'_id': aux_key, 'data': chunk})
                chunk_keys.append(aux_key)
            coll.insert_many(chunks)
            coll.replace_one({'_id': key}, {'_id':key, 'chunks':chunk_keys, 'expires':expiration_time}, True)

# ----------------------------------------------------------------------------------------------------------------------

    def _decode(self, data):
        if self._compression:
            return pickle.loads(zlib.decompress(base64.decodestring(data)))
        return pickle.loads(data)


# ----------------------------------------------------------------------------------------------------------------------

    def _encode(self, data):
        if self._compression:
            return base64.encodestring(zlib.compress(pickle.dumps(data, pickle.HIGHEST_PROTOCOL), self.compression_level))
        return Binary(pickle.dumps(data, pickle.HIGHEST_PROTOCOL))

# ----------------------------------------------------------------------------------------------------------------------

    def get(self, key, default=None, version=None):
        coll = self._get_collection()
        key = self.make_key(key, version)
        self.validate_key(key)
        data = coll.find_one({'_id': key}, max_time_ms=self._max_time_ms)
        if not data:
            return default
        expiration_time = data['expires']
        if expiration_time < datetime.datetime.now():
            coll.delete_one({'_id': key})
            return default
        raw = data.get('data')
        if not raw:
            chunks = data.get('chunks')
            if chunks:
                raw = ''
                for chunk in chunks:
                    raw += coll.find_one({'_id': chunk}, max_time_ms=self._max_time_ms)['data']
            else:
                return default
        return self._decode(raw)

# ----------------------------------------------------------------------------------------------------------------------

    def get_many(self, keys, version=None):
        coll = self._get_collection()
        out = {}
        parsed_keys = {}
        for key in keys:
            pkey = self.make_key(key, version)
            self.validate_key(pkey)
            parsed_keys[pkey] = key
        data = coll.find({'_id': {'$in': parsed_keys.keys()}}).max_time_ms(self._max_time_ms)
        for result in data:
            raw = result.get('data')
            chunks = result.get('chunks')
            if chunks:
                raw = ''
                for chunk in chunks:
                    raw += coll.find_one({'_id': chunk}, max_time_ms=self._max_time_ms)['data']
            out[parsed_keys[result['_id']]] = self._decode(raw)
        return out

# ----------------------------------------------------------------------------------------------------------------------

    def delete(self, key, version=None):
        self._coll.delete_one({'_id': key})

# ----------------------------------------------------------------------------------------------------------------------

    def has_key(self, key, version=None):
        coll = self._get_collection()
        key = self.make_key(key, version)
        self.validate_key(key)
        data = coll.find_one({'_id': key}, max_time_ms=self._max_time_ms)
        return data is not None

# ----------------------------------------------------------------------------------------------------------------------

    def clear(self):
        pass

# ----------------------------------------------------------------------------------------------------------------------

    def _cull(self):
        pass

# ----------------------------------------------------------------------------------------------------------------------

    def _get_collection(self):
        if not getattr(self, '_coll', None):
            self._initialize_collection()
        return self._coll

# ----------------------------------------------------------------------------------------------------------------------

    def _initialize_collection(self):
        try:
            from gevent import monkey
            monkey.patch_socket()
        except ImportError:
            pass

        self.connection = pymongo.MongoClient(connect=False, host=self._host, replicaset=self._rsname,
            sockettimeoutms=self._socket_timeout_ms, connecttimeoutms=self._connect_timeout_ms,
            serverSelectionTimeoutMS=self._server_selection_timeout_ms,read_preference=self._read_preference)

        self._db = self.connection[self._database]
        if self._user and self._password:
            self._db.authenticate(self._user, self._password, source=self._auth_database)
        if pymongo.version_tuple[0] < 3:
            self._coll = self._db[self._collection]
        else:
            self._coll = self._db.get_collection(self._collection)
            if not self._coll:
                if self._compression:
                    self._coll = self._db.create_collection(self._collection,
                                                            storageEngine={'wiredTiger':
                                                                            {'configString': 'block_compressor=none'}})
                else:
                    self._coll = self._db.create_collection(self._collection)
