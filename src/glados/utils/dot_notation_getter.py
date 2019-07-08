class DotNotationGetter:
    """This class allows to obtain proterties in a dictionary using a string with dots, such as
        '_metadata.assay_data.assay_subcellular_fraction'"""
    DEFAULT_NULL_LABEL = ''

    def __init__(self, obj):
        self.obj = obj

    def get_property(self, obj, str_property):
        prop_parts = str_property.split('.')
        current_prop = prop_parts[0]
        if len(prop_parts) > 1:
            current_obj = obj.get(current_prop)
            if current_obj is None:
                return self.DEFAULT_NULL_LABEL
            else:
                return self.get_property(current_obj, '.'.join(prop_parts[1::]))
        else:

            value = obj.get(current_prop)
            value = self.DEFAULT_NULL_LABEL if value is None else value
            return value

    def get_from_string(self, dot_notation_property):
        return self.get_property(self.obj, dot_notation_property)
