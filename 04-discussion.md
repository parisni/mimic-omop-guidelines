
# Discussion

1. OMOP in international context
- mapping
- concensual guidelines

2. OMOP in EHR context
	- algorithm real life application
	- juridic access
	- validation algorithm
 	- i2b2 (omop) ; FHIR / omop why fhir not replace omop.

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
