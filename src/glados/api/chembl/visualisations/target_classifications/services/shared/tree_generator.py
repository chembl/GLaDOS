from glados.usage_statistics import glados_server_statistics
import json
from elasticsearch_dsl import MultiSearch, Search


def get_nodes_index(parsed_tree_root, path=[]):
    nodes_index = {}
    for node_id, node in parsed_tree_root.items():
        path_to_node = path + [node_id]
        index_id = ';'.join(path_to_node)
        nodes_index[index_id] = node

        children = node.get('children')
        if children is not None:
            nodes_to_add = get_nodes_index(children, path_to_node)
            for key, value in nodes_to_add.items():
                nodes_index[key] = value

    return nodes_index


def load_tree_from_agg(raw_tree_root):
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
                    node['children'] = load_tree_from_agg(child_buckets)

    return parsed_tree_root


def load_tree_from_hits(hits):

    print('LOAD TREE FROM DOCS')
    print('num hits: ', len(hits))

    parsed_tree_root = {}
    nodes_index = {}

    i = 0
    for hit in hits:

        if i == 1000:
            break

        node_id = hit['_id']
        print('node_id: ', node_id)
        # Add new child, or complete its data if I have already added it before
        node = nodes_index.get(node_id)
        if node is None:
            new_node = {
                'id': node_id,
                'label': hit['_source']['pref_name'],
            }
            nodes_index[node_id] = new_node
            print('new node added')
        else:
            node['label'] = hit['_source']['pref_name']
            print('node existed already')

        current_node = nodes_index[node_id]

        # Now get the parent ID
        parent_node_id = hit['_source']['parent_go_id']
        print('parent_node_id: ', parent_node_id)
        # 2 things can happen:
        if parent_node_id is None:
            # 1: it's a root node, then I just add it to the root
            parsed_tree_root[node_id] = current_node
            print('it is a root node')
        else:
            # 2: it's NOT a root node
            # I know that a node with parent_node_id must exist, and that the current hit is its child
            parent_node = nodes_index.get(parent_node_id)
            if parent_node is None:
                # I haven't created it before, so let's create it
                new_parent_node = {
                    'id': parent_node_id,
                    'children': {
                        node_id: nodes_index[node_id]
                    }
                }
                nodes_index[parent_node_id] = new_parent_node
                print('parent is new')
            else:
                # I created it before, so I just add the current node to its children
                if parent_node.get('children') is None:
                    parent_node['children'] = {}
                parent_node['children'][node_id] = current_node

        print('---')
        i += 1
    print('nodes in index: ', len(nodes_index.keys()))
    print('nodes index: ')
    print(json.dumps(nodes_index, indent=4))
    return parsed_tree_root


def generate_count_queries(tree_root, query_generator, level=1, path=[]):
    queries = {}
    for node_id, node in tree_root.items():

        path_to_node = path + [node_id]
        query_id = ';'.join(path_to_node)
        query_string = query_generator(path_to_node)

        queries[query_id] = {
            'query': query_string
        }
        children = node.get('children')
        if children is not None:
            queries_to_add = generate_count_queries(children, query_generator, level + 1, path_to_node)
            for key, value in queries_to_add.items():
                queries[key] = value

    return queries


class TargetHierarchyTreeGenerator:
    def __init__(self, index_name, es_query, query_generator):

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

        self.parsed_tree_root = load_tree_from_agg(self.raw_tree_root)
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

        for node_path_str, query in self.count_queries.items():
            self.nodes_index[node_path_str]['target_count'] = query['count']
            self.nodes_index[node_path_str]['query_string'] = query['query']


class GoSlimTreeGenerator(TargetHierarchyTreeGenerator):
    """
    This generates a tree directly by reading the nodes, not by using aggregations
    """

    def __init__(self):
        self.index_name = 'chembl_go_slim'
        self.es_query = {
            "size": 1000,
            "from": 0
        }

        def generate_count_query(path_to_node):
            queries = []
            level = 1
            for node in path_to_node:
                queries.append(
                    '_metadata.target_component.go_slims.go_id:("{class_name}")'.format(class_name=node))
                level += 1

            return ' AND '.join(queries)

        self.query_generator = generate_count_query
        self.raw_tree_root = None
        self.parsed_tree_root = {}
        self.count_queries = {}
        self.nodes_index = {}

    def get_classification_tree(self):

        es_response = glados_server_statistics.get_and_record_es_cached_response(self.index_name,
                                                                                 json.dumps(self.es_query))

        self.raw_tree_root = es_response['hits']['hits']
        self.build_final_tree()

        return self.parsed_tree_root

    def build_final_tree(self):

        print('BUILD FINAL TREE')
        self.parsed_tree_root = load_tree_from_hits(self.raw_tree_root)
        # self.load_target_counts()

