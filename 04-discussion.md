
# Discussion

1. OMOP in international context
- mapping
- concensual guidelines

2. OMOP in EHR context
	- algorithm real life application
	- juridic access
	- validation algorithm
 	- i2b2 (omop) ; FHIR / omop why fhir not replace omop.

NOTE_NLP table: At the time of this study, the table is presented by the OMOP
community as an experimental table. It is clearly a powerful tool and this
evaluation has shown some limitation and some proposal for this. While the
initial idea of the authors clearly indicates that final results from nlp
pipelines only should be stored in the table, we clearly ask the question
wether storing intermediary results in the table such sections, pos tagging, is
of interest for community work. At the very end, should final information such
condition, heart rate extracted from notes may not be inserted as derived
information in dedicated tables such condition_occurrence and measurement
tables and the note_nlp table be used more as a working table for storing and
evaluating intermediary results dedicated to text-miners.

-------------

**database modelling**

- advantages of normalized 
- disadvantages of normalized
- advantages of packed tables
- disadvantages of packed tables
- need to propose an optimized version of OMOP -> ==XT: is that the idea of flattenning the tables to improve query-ability? OMOP Analytics? technical performances == -> ==NP: indeed, precalcul most of joins so that queries are focused on one or two table instead of 5 and more ; in this case, replicating information is not a problem because it is a frozen dataset and replicated field all come from one unique field and this is then no error prone by design==
==XT: What are the pros and cons of this solution against keeping the structure but producing some "query plans" for the frequent accesses? Several participants at dat-icu told me that at the end of the end, most of the teams struggled to finally produce queries that were very similar to their neighbors' queries==

**terminology mapping**

- athena existing standard mapping
- athena missing concepts

What else could have been done instead?

- use of automatic concept mapping processes: but their performances are not yet as good as human manual mapping.
- large community mapping: this was too early to open the work to public so that effort and direction could be kept



OMOP model
- enables observational studies to be conducted using multiple data sources
-  while confidential personal health data remain with the original data holders
