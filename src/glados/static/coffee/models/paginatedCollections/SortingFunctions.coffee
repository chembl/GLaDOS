glados.useNameSpace 'glados.models.paginatedCollections',

  SortingFunctions:
    # organises the information of the columns that are going to be sorted.
    # returns true if the sorting needs to be descending, false otherwise.
    setupColSorting: (columns, comparator) ->

      is_descending = false

      for col in columns

        # set is_sorting attribute for the comparator column
        if col.comparator == comparator

          col.is_sorting = switch col.is_sorting
            when 0 then 1
            else -col.is_sorting

          is_descending = col.is_sorting == -1

        else
        # for the rest of the columns is zero
          col.is_sorting = 0

        # now set the class for font-awesome
        # this was the simplest way I found to do it, handlebars doesn't provide a '==' expression

        col.sort_class = switch col.is_sorting
          when -1 then 'fa-sort-desc'
          when 0 then 'fa-sort'
          when 1 then 'fa-sort-asc'

      return is_descending