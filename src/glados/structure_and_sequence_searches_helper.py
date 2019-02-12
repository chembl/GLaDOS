# this handles the management of the special searches, structure (similarity, substructure, connectivity) and
# sequence (blast)
from glados.models import StructureSearchJob


class SSSearchError(Exception):
    """Base class for exceptions in this file."""
    pass


def do_search(search_type, search_params):
    print('DO SEARCH')
    print('search_type: ', search_type)

    search_types = [s[0] for s in StructureSearchJob.SEARCH_TYPES]
    if search_type not in search_types:

        raise SSSearchError(
            "search_type: {} is unknown. Possible types are: {}".format(search_type, ', '.join(search_types))
        )

    job_id = '666'

    response = {
        'search_id': job_id
    }
    return response
