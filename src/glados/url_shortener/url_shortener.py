import hashlib

#given a long url, it shortens it and saves it in elastic, it returns the hash obtained
def shorten_url(long_url):

  short_url = hashlib.sha256(long_url).hexdigest()
  return short_url