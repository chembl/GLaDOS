{
  "explain": true
  "size": 2
  "from": 0
  "query":
    "constant_score":
      "query":
        "query_string":
          "fields": ["*.ngram_analyzed", "*.keyword^10000"]
          "query" : "Acetylsalicylic Acid"
}