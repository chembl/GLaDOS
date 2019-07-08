{
  "size": 10
  "from": 0
  "_source": ["target_chembl_id"]
  "query":
    "bool":
      "must": [
        {
          "term":
            "target_type": "SINGLE PROTEIN"
        },
        {
          "multi_match":
            "type": "best_fields",
            "query": "<T_NAME>",
            "fields": ["target_components.target_component_synonyms.component_synonym.std_analyzed",
            "target_components.target_component_synonyms.component_synonym.eng_analyzed"
            ],
            "minimum_should_match": "70%"
        }
      ]
}