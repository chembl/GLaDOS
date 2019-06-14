def get_search_source(columns_to_download):
    return [col['property_name'] for col in columns_to_download]


def write_something_separated_values_file():
    print('Writing file!')