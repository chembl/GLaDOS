# This handles all the functions related to the heatmap helper structure and endpoints.


def generate_heatmap_initial_data(index_name, raw_search_data):

    print('generate initial data')
    print('index_name: ', index_name)
    print('raw_search_data: ', raw_search_data)

    # get aggregation from elasticsearch
    # TODO: check es_connection to use DATA or MONITORING connection
    # add_response = connections.get_connection().search(index=index_name, body=search_data)
