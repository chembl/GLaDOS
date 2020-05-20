import copy
from concurrent.futures import ThreadPoolExecutor
from threading import Thread
import glados.es.ws2es.signal_handler as signal_handler
import time
from wrapt.decorators import synchronized
import re
from concurrent.futures import Future
import sys

PROPERTY_REGEX = re.compile('[0-9A-Za-z_]*')
PROPERTY_NAME_IDS = {}
CAPS_REGEX = re.compile('[A-Z]')
VOWELS_REGEX = re.compile('[aeiouy]', flags=re.IGNORECASE)
SPACE_REGEX = re.compile(r'\s')
REPEATED_CHARACTERS_REGEX = re.compile(r'(.)\1+')


def complete_futures_values(doc_or_list):
    if isinstance(doc_or_list, list):
        for i, item_i in enumerate(doc_or_list):
            if isinstance(item_i, dict) or isinstance(item_i, list):
                complete_futures_values(item_i)
            elif isinstance(item_i, Future):
                doc_or_list[i] = item_i.result()
    if isinstance(doc_or_list, dict):
        for key_i in doc_or_list:
            value_i = doc_or_list[key_i]
            if isinstance(value_i, dict) or isinstance(value_i, list):
                complete_futures_values(value_i)
            elif isinstance(value_i, Future):
                doc_or_list[key_i] = doc_or_list[key_i].result()

def remove_duplicate_words(sentence):
    words = SPACE_REGEX.split(sentence)
    words_set = set()
    clean_sentence = ''
    for word in words:
        if word.lower() == 'pref':
            continue
        if word not in words_set:
            clean_sentence += word + ' '
            if word.endswith('s'):
                words_set.add(word[:-1])
            elif word.endswith('es'):
                words_set.add(word[:-2])
            elif word.endswith('ies'):
                words_set.add(word[:-3])
            else:
                words_set.add(word)
    return clean_sentence


def standardize_label(prop_part, entity_name=None):
    std_label = re.sub('_+', ' ', prop_part).strip()
    std_label = std_label.title()
    std_label = re.sub(r'\batc\b', 'ATC', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\bbao\b', 'BAO', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\bchembl\b', 'ChEMBL', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\bid\b', 'ID', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\busan\b', 'USAN', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\bbei\b', 'BEI', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\ble\b', 'LE', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\blle\b', 'LLE', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\bsei\b', 'SEI', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\befo\b', 'EFO', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\buberon\b', 'UBERON', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\bmesh\b', 'MESH', std_label, flags=re.IGNORECASE)
    std_label = re.sub(r'\bnum\b', '#', std_label, flags=re.IGNORECASE)
    if entity_name is not None:
        std_label = re.sub(r'\bgenerated\b', '', std_label, flags=re.IGNORECASE)
        std_label = re.sub(r'\b' + entity_name + r'\b', '', std_label, flags=re.IGNORECASE)
        if entity_name == 'molecule':
            std_label = re.sub(r'\bcompound\b', '', std_label, flags=re.IGNORECASE)
        if entity_name == 'cell_line':
            std_label = re.sub(r'\bcell\b', '', std_label, flags=re.IGNORECASE)
            std_label = re.sub(r'\bline\b', '', std_label, flags=re.IGNORECASE)

    return std_label.strip()


def abbreviate_word(word, max_word_length):
    if len(word) <= max_word_length:
        return word
    total_caps = len(CAPS_REGEX.findall(word))
    if total_caps > round(len(word) / 2):
        return word
    inner_word = word[1:]
    next_vowel_match = VOWELS_REGEX.search(inner_word)
    if next_vowel_match is not None:
        next_vowel_idx = next_vowel_match.pos
        after_vowel = inner_word[next_vowel_idx + 1:]
        pre_vowel = inner_word[:next_vowel_idx + 1]

        inner_word = pre_vowel + VOWELS_REGEX.sub('', after_vowel)
        if REPEATED_CHARACTERS_REGEX.search(inner_word):
            inner_word = REPEATED_CHARACTERS_REGEX.sub(r'\1', inner_word)
    return word[0] + inner_word[:max_word_length - 1] + '.'


def abbreviate_label(std_label):
    words = SPACE_REGEX.split(std_label)
    max_word_length = 10
    if 15 < len(std_label) <= 20:
        max_word_length = 6
    elif len(std_label) > 20:
        max_word_length = 4

    abbreviated_words = []
    for word in words:
        abbreviated_words.append(abbreviate_word(word, max_word_length))
    return ' '.join(abbreviated_words)


def get_labels_from_property_name(entity_name, prop_name):
    prop_parts = prop_name.split('.')
    label = ''
    if len(prop_parts) > 1:
        if not prop_parts[-2] in ['_metadata', 'drug_data']:
            if not prop_parts[-2] in ['molecule_properties', 'drug']:
                label += standardize_label(prop_parts[-2], entity_name) + ' '
    label += standardize_label(prop_parts[-1], entity_name)
    if len(label) == 0:
        label = standardize_label(prop_parts[-1])
    label = remove_duplicate_words(label)
    label = label.strip()
    label_mini = abbreviate_label(label)
    return label, label_mini


def get_js_path_from_dict(doc: dict, js_path, default=None):
    if doc is None:
        return None
    js_path_parts = js_path.split('.')
    cur_level = doc
    for js_path_part_i in js_path_parts:
        if isinstance(cur_level, list):
            next_level = []
            for cur_level_j in cur_level:
                if isinstance(cur_level_j, dict):
                    if js_path_part_i in cur_level_j:
                        next_level.append(cur_level_j[js_path_part_i])
            cur_level = next_level
            if len(cur_level) == 0:
                break
        else:
            cur_level = cur_level.get(js_path_part_i, None)
            if cur_level is None:
                break
    if default is not None and cur_level is None:
        return default
    return cur_level


def put_js_path_in_dict(doc: dict, js_path, value, es_properties_style=False):
    if doc is None:
        doc = {}
    if es_properties_style:
        js_path = js_path.replace('.', '.properties.')

    # remove trailing and leading '.'
    if js_path[0] == '.':
        js_path = js_path[1:]
    if js_path[-1] == '.':
        js_path = js_path[:-1]

    js_path_parts = js_path.split('.')
    cur_level = doc
    for i, js_path_part_i in enumerate(js_path_parts):
        if i == len(js_path_parts)-1:   # if last
            cur_level[js_path_part_i] = value
        else:
            if js_path_part_i not in cur_level or not isinstance(cur_level[js_path_part_i], dict):
                cur_level[js_path_part_i] = {}
            cur_level = cur_level[js_path_part_i]
    return doc


class SummableDict(dict):

    @staticmethod
    def is_subclass_of_dict(obj):
        return issubclass(obj.__class__, dict)

    @staticmethod
    def mix_dicts(dict_a, dict_b):
        for key_i in dict_b.keys():
            if key_i in dict_a and SummableDict.is_subclass_of_dict(dict_a[key_i]) \
                    and SummableDict.is_subclass_of_dict(dict_b[key_i]):
                SummableDict.mix_dicts(dict_a[key_i], dict_b[key_i])
            else:
                dict_a[key_i] = dict_b[key_i]

    def __add__(self, other):
        self_copy = copy.deepcopy(self)
        if SummableDict.is_subclass_of_dict(other):
            SummableDict.mix_dicts(self_copy, other)
        elif other and issubclass(other.__class__, (tuple, list)) and len(other) == 2:
            self_copy[other[0]] = other[1]
        else:
            raise Exception("ERROR: Unsupported type! Must add a dictionary or a tuple or list of size 2.")
        return self_copy

    def __sub__(self, keys_list):
        for key_i in keys_list:
            self.pop(key_i, None)
        return self


def count_fields_in_doc(doc):
    cur_count = 0
    if isinstance(doc, list):
        for sub_doc in doc:
            cur_count += count_fields_in_doc(sub_doc)
    elif isinstance(doc, dict):
        for sub_doc in doc.values():
            cur_count += count_fields_in_doc(sub_doc)
    else:
        cur_count += 1
    return cur_count


# noinspection PyBroadException
class SharedThreadPool(Thread):

    def __init__(self, max_workers=10, label='SharedThreadPool'):
        super().__init__()
        self.max_workers = max_workers
        self.max_queue_size = max_workers * 1000
        self.current_tasks_queue = []
        self.thread_pool = ThreadPoolExecutor(max_workers=max_workers)
        self.stop_thread_pool = False
        self.label = label
        signal_handler.add_termination_handler(self.stop_pool)

    def stop_pool(self, signal, frame):
        self.stop_thread_pool = True

    @synchronized
    def check_finished_tasks(self):
        next_queue = []
        for task_i in self.current_tasks_queue:
            if not task_i.done():
                next_queue.append(task_i)
        del self.current_tasks_queue
        self.current_tasks_queue = next_queue

    @synchronized
    def get_tasks_queue_length(self):
        return len(self.current_tasks_queue)

    @synchronized
    def add_task_to_queue(self, task):
        self.current_tasks_queue.append(task)

    def submit(self, fn, *args, **kwargs):
        return_future = None
        while self.get_tasks_queue_length() >= self.max_queue_size and not self.stop_thread_pool:
            time.sleep(0.2)
        if not self.stop_thread_pool:
            return_future = self.thread_pool.submit(fn, *args, **kwargs)
            self.add_task_to_queue(return_future)
        return return_future

    def join(self, timeout=None):
        self.thread_pool.shutdown(wait=True)
        self.stop_thread_pool = True
        super().join(timeout=timeout)

    def run(self):
        while not self.stop_thread_pool:
            if self.get_tasks_queue_length() > 0:
                self.check_finished_tasks()
            else:
                time.sleep(0.2)


def query_yes_no(question, default="yes"):
    """
    Ask a yes/no question via raw_input() and return their answer.

    "question" is a string that is presented to the user.
    "default" is the presumed answer if the user just hits <Enter>.
        It must be "yes" (the default), "no" or None (meaning
        an answer is required of the user).

    The "answer" return value is True for "yes" or False for "no".
    """
    valid = {"yes": True, "y": True, "ye": True,
             "no": False, "n": False}
    if default is None:
        prompt = " [y/n] "
    elif default == "yes":
        prompt = " [Y/n] "
    elif default == "no":
        prompt = " [y/N] "
    else:
        raise ValueError("invalid default answer: '%s'" % default)

    while True:
        sys.stdout.write(question + prompt)
        choice = input().lower()
        if default is not None and choice == '':
            return valid[default]
        elif choice in valid:
            return valid[choice]
        else:
            sys.stdout.write("Please respond with 'yes' or 'no' "
                             "(or 'y' or 'n').\n")
