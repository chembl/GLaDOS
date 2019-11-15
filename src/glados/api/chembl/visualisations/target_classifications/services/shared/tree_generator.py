from glados.usage_statistics import glados_server_statistics
import json
from elasticsearch_dsl import MultiSearch, Search


def get_nodes_index(parsed_tree_root):

    nodes_index = {}
    for node_id, node in parsed_tree_root.items():
        nodes_index[node_id] = node

        children = node.get('children')
        if children is not None:
            nodes_to_add = get_nodes_index(children)

            for key, value in nodes_to_add.items():
                nodes_index[key] = value

    return nodes_index


def load_tree(raw_tree_root):

    parsed_tree_root = {}
    for item in raw_tree_root:
        item_id = item['key']
        node = {
            'id': item_id
        }
        parsed_tree_root[item_id] = node

        children = item.get('children')
        if children is not None:
            child_buckets = children.get('buckets')
            if child_buckets is not None:
                if len(child_buckets) > 0:
                    node['children'] = load_tree(child_buckets)

    return parsed_tree_root


def generate_count_queries(tree_root, query_generator, level=1):

    queries = {}
    for node_id, node in tree_root.items():
        query_string = query_generator(level, node_id)

        queries[node_id] = {
            'query': query_string
        }
        children = node.get('children')
        if children is not None:
            queries_to_add = generate_count_queries(children, query_generator, level + 1)
            for key, value in queries_to_add.items():
                queries[key] = value

    return queries


class TargetHierarchyTreeGenerator:

    def __init__(self, index_name, es_query, query_generator):

        print('init TargetHierarchyTreeGenerator')
        print('index_name: ', index_name)
        print('es_query: ', es_query)

        self.index_name = index_name
        self.es_query = es_query
        self.query_generator = query_generator
        self.raw_tree_root = None
        self.parsed_tree_root = {}
        self.count_queries = {}
        self.nodes_index = {}

    def get_classification_tree(self):

        es_response = glados_server_statistics.get_and_record_es_cached_response(self.index_name,
                                                                                 json.dumps(self.es_query))
        self.raw_tree_root = es_response['aggregations']['children']['buckets']
        self.build_final_tree()

        return self.parsed_tree_root

    def build_final_tree(self):

        self.parsed_tree_root = load_tree(self.raw_tree_root)
        self.load_target_counts()

    def load_target_counts(self):

        self.nodes_index = get_nodes_index(self.parsed_tree_root)
        self.count_queries = generate_count_queries(self.parsed_tree_root, self.query_generator)
        self.execute_count_queries()
        self.add_counts_to_tree()

    def execute_count_queries(self):

        ms = MultiSearch(index='chembl_target')

        target_classes = list(self.count_queries.keys())  # be sure to be consistent with the order

        for target_class in target_classes:
            current_query_string = self.count_queries[target_class]['query']
            query = {
                "query_string": {
                    "_name": current_query_string,
                    "query": current_query_string,
                }
            }

            ms = ms.add(Search().query(query))

        responses = ms.execute()

        i = 0
        for response in responses:
            class_name = target_classes[i]
            self.count_queries[class_name]['count'] = response.hits.total
            i = i + 1

    def add_counts_to_tree(self):

        for class_name, query in self.count_queries.items():
            self.nodes_index[class_name]['target_count'] = query['count']