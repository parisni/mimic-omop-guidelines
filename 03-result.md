# Results

## comparaison MIMICIII / MIMIC OMOP (basic statistics)

| items					|OMOP-MIMIC 			| MIMICIII |
|---------------------------------------|-------------------------------|----------|
| Persons (Number) 			| 46.520 			| 46.520 |
| Admissions (Number) 			| 58.976 			| 58.976 |
| Icustays (Number)   			| 61.532 			| 71.576 |
| Age (Mean)  				| 64 ans, 4 months 		| 64 years, 4 monts |
| Gender, Female (Number, %) 	       	| 20.399 (43 %)               	| 20.399 |
| Length of stay, hospital (median) 	| 6.59 (Q1-Q3 : 3.84 - 11.88) 	| 6.46 (Q1-Q3 : 3.74 -11.79) |
| Length of stay, ICU (median)      	| 1.87 (Q1-Q3 : 0.95 - 3.87)  	| 2.09 (Q1-Q3 : 1.10 - 4.48) |
| Mortality, ICU (Number, %)        	| 5815 (9%)                   	| 5814 (9%) |
| Mortality, hospital (Number, %)   	| 4559 (6%)                   	| 4511 (7%) |
| Lab measurement per admissions (mean) |                    		|  |

cf extra : basic_statistics.sql

## loss of data (try to quantify it)
- percent of records loaded from the source database to the CDM 
    - percent of columns
    - percent of rows
  as have done other studies (1) 

- Row
 
| items                             |rows per persons|
|-----------------------------------|----------------|
| Nb patients                       | 100 % |
| Nb admissions                     | 100 % |
| Procedures                        |  % |
| Admissions diagnosis              |  % |
| Exit diagnosis                    |  % |
| Laboratory exams                  |  % |
| Physical exams                    |  % |
| Drugs                             |  % |
| Notes                             |  % |

remark all the error lign are deleted

- Columns
% of sources columns which fits to CDM
ex : storetime and chartime

## terminology mapping coverage
- ICD-9-CM 
   A part of source data for condition_occurrence was ICD-9 codes. 
   The OMOP common standard vocabulary, SNOMED-CT, did not cover all ICD-9-CM codes (95%)
   Moreover, not all ICD-9-CM codes can have one-to-one mapping to SNOMED, some are one-to-many (28%)
   https://www.nlm.nih.gov/research/umls/mapping_projects/icd9cm_to_snomedct.html
- LOINC
- RxNorm

- % of standard_concept_id = 0 (No mapping concept) per table
Need colaborative work

- % of domain_id not in adequation with table name 

- we have mapped  many source concept to one standard concept
  is it the same meaning? distribution of values sometimes very different

## derived values / data / scores
- F/P, corrected Ca / K, BMI
- Note_NLP
- SOFA, SAPSII

## dat-icu feedbacks (most of queries under 30 second ; simplified model VS MIMIC ; to much normalized for data scientist)


1. F. FitzHenry Creating a Common Data Model for Comparative Effectiveness with the Observational Medical Outcomes Partnership. Appl Clin Inform 2015; 6: 536–547
