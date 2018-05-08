# table populated with their mimic source table link
The OMOP-CDM contains n data tables. We populated m tables.
From MIMICIII we create a standardized model called MIMICIII-OMOP.

| Omop tables    	| Source tables|
|-----------------------|--------------|
| PERSONS 		| patients, admissions |
| DEATH 		| patients, admissions |
| VISIT_OCCURRENCE 	| admissions |
| VISIT_DETAIL 		| transfers, service |
| MEASUREMENT 		| chartevents, labevents, microbiologyevents, outputevents |
| OBSERVATION 		| admissions, chartevents, datetimevvents, drgcodes |
| DRUG_EXPOSURE 	| prescriptions, inputevents_cv, inputevents_mv|
| PROCEDURE_OCCURRENCE 	| cptevents, procedureevents_mv, procedure_icd|
| CONDITION_OCCURRENCE 	| admissions, diagnosis_icd |
| NOTE 			| notevents|
| NOTE_NLP 		| noteevents |
| COHORT_ATTRIBUTE 	| callout |
| CARE_SITE 		| trasnfers, service |
| PROVIDER 		| caregivers |
| OBSERVATION_PERIOD 	| patients, admissions |
| SPECIMEN 	 	| chartevents, labevents, microbiologyevents |

- observation_period provide duplicate information: we fill this table to respect the omop model and tools

# Quality evaluation

##  comparaison MIMICIII / MIMIC OMOP (basic statistics)
The table lists the baseline characterization of the population of MIMICIII-OMOP compared with MIMICIII.

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

papier + test

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

remark all the error rows are deleted ( prescriptions, inputevents_mv, chartevents, procedureevents_mv, note)

- Columns
% of sources columns which doesn't fits to CDM
storetime!!

## terminology mapping coverage
- ICD-9-CM 
   A part of source data for condition_occurrence was ICD-9 codes. 
   The OMOP common standard vocabulary, SNOMED-CT, did not cover all ICD-9-CM codes (95%)
   Moreover, not all ICD-9-CM codes can have one-to-one mapping to SNOMED, some are one-to-many (28%)(2)
- LOINC
- RxNorm

- % of standard_concept_id = 0 (No mapping concept) per table
Need colaborative work

- % of domain_id not in adequation with table name 
	- some are logical because observation domain may be measurement table and vice verca

- we have mapped  many source concept to one standard concept
  is it the same meaning? distribution of values sometimes very different

## ACHILLES evaluation
ACHILLES is open-source software application developped by OHDSI and Achilles Heel provided data quality checker
Other team used this tool to practice data quality assess(4).
Our result ...

# Community sharing

We provided many derived values. Community is welcome to improve it
- F/P, corrected Ca / K, BMI
- Note_NLP with section splitting. The algorythm is freely accessible here
- SOFA, SAPSII

# Feedbacks of real MIMICIII-OMOP testing
- this work has been done with APHP to test OMOP model in real statistical condition. A datathon was organised in collaboration with the MIT.(3)
We also test the big data APHP platforms.
- most of queries under 30 second ; simplified model VS MIMIC ; to much normalized for data scientist)

# others
- estimation of number of work hours
- ethnicity_concept_id : only two strange concept_name hispanic or non_hispanic
- size of MIMIC OMOP, row number for the bigest relation (measurement)
- chartevents and lavents provide many number field as a string which is not handy for statistical analyse. We provide a standard and easy improval by the community model to extract numerical value from string
	- operators have been extracted to fill operator_concept_id column
	- numeric value has been extracted to fill value_as_number column
	- units of measures have been extracted to fill unit_concept_id column

1. F. FitzHenry Creating a Common Data Model for Comparative Effectiveness with the Observational Medical Outcomes Partnership. Appl Clin Inform 2015; 6: 536–547
2. https://www.nlm.nih.gov/research/umls/mapping_projects/icd9cm_to_snomedct.html
3. http://blogs.aphp.fr/dat-icu/
4. Y.Dukyong and Al.Conversion and Data Quality Assessment of Electronic Health Record Data at a Korean Tertiary Teaching Hospital to a Common Data Model for Distributed Network Research.Healthcare Informatics Research 2016; 54
