# ES properties configutation module

This goal of this module is to help to handle the high ammount and complexity of the different properties in ChEMBL. There are 9 main indexes in ChEMBL (Activity, Compound, Target, Assay, Document, Cell Line, Tissue, Mechanism Of Action, and Drug Indications). Each of them has their own set of properties, which are used in different parts of the interface and the downloads. 

For exampe, when the user sees a [table of activities](https://www.ebi.ac.uk/chembl/g/#browse/activities), it only shows a subset of properties of an index, some properties are shown by default, and others can be added to the table. There is also a subset of properties for the avaiable filters, and similarly, the set of properties included in a downloaded file is another subset of all the properties available in the index. 

## Getting the configuration of one property

Given an **index name** and a **property id**, it returns the following information:

- Type.
- If it is aggregatable.
- The full label.
- A short version of the label.

# Parsing a property

It parses the returned value from eleasticsearch given the functions defined in columns_parser.py, if there is no 
parsing function it will return the original value. 

