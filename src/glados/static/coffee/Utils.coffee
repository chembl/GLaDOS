glados.useNameSpace 'glados',
  Utils:
    # this is to support using dots for nested properties in the list settings
    #for example, if you have the following object
    # a = {
    #    b: {
    #      c: 2
    #       }
    #     }
    # you can use the function like this getNestedValue(a, 'b.c'.split('.'))
    getNestedValue: (nestedObj, nestedComparatorsStr) ->

      nestedComparatorsList = nestedComparatorsStr.split('.')
      if nestedComparatorsList.length == 1
        return nestedObj[(nestedComparatorsList.shift())]
      else
        prop = nestedComparatorsList.shift()
        newObj = nestedObj[(prop)]
        if !newObj?
          return glados.Settings.DEFAULT_NULL_VALUE_LABEL

        return @getNestedValue(newObj, nestedComparatorsList.join('.'))
