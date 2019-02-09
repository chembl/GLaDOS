import requests
import logging

logger = logging.getLogger('django')


def get_similarity(compound):

    url = "http://193.62.52.90:8888/similarity/0.7"
    r = requests.post(url, compound)
    logger.info(r)
    similarity = r.json()

    return similarity
