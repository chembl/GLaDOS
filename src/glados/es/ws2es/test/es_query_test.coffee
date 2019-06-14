{
  "explain": true
  "size": 10
  "from": 0
  "query":
    "bool":
      "should":[
        [
          "multi_match":
            "query": "<SEARCH_STRING>"
            "type": "phrase",
            "fields": ["*.pref_name_analyzed^2", "*.alt_name_analyzed"]
            "slop" : "10"
        ]
      ]
}