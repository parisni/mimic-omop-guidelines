1. ETL
#######

2. ANALYTICS
############

- consize model, simple
- normalized, but materialized views is a solution.
- standardized code

3. CONTRIB
###########

- sopha from dataforgood ?

NLP: The

summary table of note and section mapping
=========================================

with tmp as (select count(1) as count,round(median(c)) as median, round(avg(c),1) as avg, max(c) as max, note_source_value as mimic_category, c1.concept_name as omop_category from note left join concept c1 on note_type_concept_id = c1.concept_id left join (select note_id, count(1) as c from note_nlp group by note_id) as note_nlp using (note_id)  group by note_source_value, c1.concept_name) select mimic_category, omop_category, count as  document_count, median as section_median, avg as section_mean, max as section_max from tmp order by 2 asc;

  mimic_category   |   omop_category   | document_count | section_median | section_mean | section_max 
-------------------+-------------------+----------------+----------------+--------------+-------------
 Case Management   | Ancillary report  |            953 |              5 |          6.3 |          16
 Nutrition         | Ancillary report  |           9400 |              8 |          9.6 |          23
 Pharmacy          | Ancillary report  |            101 |              3 |          2.3 |           3
 Rehab Services    | Ancillary report  |           5408 |             20 |         23.5 |          74
 Respiratory       | Ancillary report  |          31701 |             24 |         24.1 |          35
 Social Work       | Ancillary report  |           2661 |              2 |          7.2 |          23
 Discharge summary | Discharge summary |          59652 |             29 |         28.0 |          76
 Physician         | Inpatient note    |         141281 |             56 |         56.3 |          98
 General           | Inpatient note    |           8236 |              2 |          6.5 |          82
 Consult           | Inpatient note    |             98 |             43 |         37.5 |          63
 Nursing           | Nursing report    |         223182 |              1 |          3.2 |          49
 Nursing/other     | Nursing report    |         822497 |              1 |          1.0 |           1
 ECG               | Pathology report  |         209051 |              1 |          1.0 |           1
 Echo              | Pathology report  |          45794 |             21 |         20.5 |          25
 Radiology         | Radiology report  |         522279 |              5 |          5.7 |          



Tokenizer evaluation: The stanford parser have been evaluated in several studies. The ctakes parser has a specialized
Myocardial infaction evaluation: Last but not least, this pipeline exploits two pipelines described above. It's evaluation thought a challenge testifies the approach works and might benefit from improvements.
All those NLP pipelines are interdependent. Improving one step would result in general improvement. Community work might apply here and subsequent result be used into cohort discovery or data-science feature extraction by analyst without prior knowledge in NLP. In order to be able to improve NLP results, an evaluation framework need to be built up. The NOTE_NLP table might be populated with gold standard manually annotated notes too.
While sections, sentences, and token are intermediary results, we believe that is is important to store them. This has several advantages: it helps text-miners. This has a severe drawback: the table becomes huge with potentially billions of rows POS tagging for each token.

table populated with their mimic source table link
=====================================================

The OMOP-CDM contains 14 data tables. We populated m tables.
From MIMICIII we create a standardized model called MIMICIII-OMOP.
This table shows where the informations goes. 
As OMOP is a conceptual model, a same type of data goes in the same table. The best example may be the measurement table which is field by 4 source tables. Is is because of the numerics datas should go to this table.

| Omop tables    	|Number of rows| Source tables|
|-----------------------|--------------|--------------|
| PERSONS 		|46520 |patients, admissions |
| DEATH 		|14849 |patients, admissions |
| VISIT_OCCURRENCE 	|58976 |admissions |
| VISIT_DETAIL 		|271808 |transfers, service |
| MEASUREMENT 		|366272371 |chartevents, labevents, microbiologyevents, outputevents |
| OBSERVATION 		|6721040|admissions, chartevents, datetimevvents, drgcodes |
| DRUG_EXPOSURE 	|24934758 |prescriptions, inputevents_cv, inputevents_mv|
| PROCEDURE_OCCURRENCE 	|1063525 |cptevents, procedureevents_mv, procedure_icd|
| CONDITION_OCCURRENCE 	|716595 |admissions, diagnosis_icd |
| NOTE 			|2082294 |notevents|
| NOTE_NLP 		|16350855 |noteevents |
| COHORT_ATTRIBUTE 	| 2628838|callout |
| CARE_SITE 		|93 |trasnfers, service |
| PROVIDER 		|7567 |caregivers |
| OBSERVATION_PERIOD 	|58976 |patients, admissions |
| SPECIMEN 	 	|39874171 |chartevents, labevents, microbiologyevents |

Ajouter schema

Quality evaluation
====================

comparison MIMICIII / MIMIC OMOP (basic statistics)
***************************************************

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
| Lab measurement per admissions (mean) | 678  (from labevents + charevents) | 478 (from labevents)|

We can see that we increase the number of laboratory measurement per admissions.
This is because the laboratory datas from chartevents has been extract and treated as laboratory
All the code to created this statistics are provided here (cf extra : basic_statistics.sql)

loss of data (try to quantify it)
*********************************
We tried to evaluate the percentage  of records loaded from the source database to the CDM
We evaluate the percentage of columns and the percentage of rows as have done other studies (1) 

- for the rows no data were lost. 
Two main remarks. 
        - We erased the error rows are deleted (inputevents_mv, chartevents, procedureevents_mv, note). As MIMIC team told us that they will remove it in the next release because this datas are poor quality we decided to do the same. 
| Table              | Error Percentage |
| inputevents_mv     | 10% |
| chartevents        | 0.04% |
| procedureevents_mv | 3% |
| Note               | 0.04% |
        - We incresed the number of ICU stay by 116% (71.576 vs 61.532). This is because our ETL methodology as we explained in the methods.

- Columns
50 % of sources columns which doesn't fits to CDM where erased. Almost all the removed columns are useless or redundant with other. In mimic for some datas there are two timestamps. One called storetime the other called charttime. The OMOP model can't store two timestamp for one data. The storetime was deleted
storetime!!


terminology mapping coverage
***************************
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

ANALYTICS
###########
- consize model, simple
- normalized, but materialized views is a solution.
- standardized code

ACHILLES evaluation
===================

ACHILLES is open-source software application developped by OHDSI and Achilles Heel provided data quality checker
Other team used this tool to practice data quality assess(4).
Our result ...
- Quality control
- 18h 50k patients: this testifies the model needs structural optimisations
- difficulté pour ajoute fr. 
- extension achilles how to ?
- comparison with other paper about error/warnings.

OMOP in real life
=================
- datathon
- dataforgood
- this work has been done with APHP to test OMOP model in real statistical condition. A datathon was organised in collaboration with the MIT.(3)
We also test the big data APHP platforms.
- most of queries under 30 second ; simplified model VS MIMIC ; to much normalized for data scientist)

CONTRIB
###########

summary table of note and section mapping
=========================================

with tmp as (select count(1) as count,round(median(c)) as median, round(avg(c),1) as avg, max(c) as max, note_source_value as mimic_category, c1.concept_name as omop_category from note left join concept c1 on note_type_concept_id = c1.concept_id left join (select note_id, count(1) as c from note_nlp group by note_id) as note_nlp using (note_id)  group by note_source_value, c1.concept_name) select mimic_category, omop_category, count as  document_count, median as section_median, avg as section_mean, max as section_max from tmp order by 2 asc;
  mimic_category   |   omop_category   | document_count | section_median | section_mean | section_max 
-------------------+-------------------+----------------+----------------+--------------+-------------
 Case Management   | Ancillary report  |            953 |              5 |          6.3 |          16
 Nutrition         | Ancillary report  |           9400 |              8 |          9.6 |          23
 Pharmacy          | Ancillary report  |            101 |              3 |          2.3 |           3
 Rehab Services    | Ancillary report  |           5408 |             20 |         23.5 |          74
 Respiratory       | Ancillary report  |          31701 |             24 |         24.1 |          35
 Social Work       | Ancillary report  |           2661 |              2 |          7.2 |          23
 Discharge summary | Discharge summary |          59652 |             29 |         28.0 |          76
 Physician         | Inpatient note    |         141281 |             56 |         56.3 |          98
 General           | Inpatient note    |           8236 |              2 |          6.5 |          82
 Consult           | Inpatient note    |             98 |             43 |         37.5 |          63
 Nursing           | Nursing report    |         223182 |              1 |          3.2 |          49
 Nursing/other     | Nursing report    |         822497 |              1 |          1.0 |           1
 ECG               | Pathology report  |         209051 |              1 |          1.0 |           1
 Echo              | Pathology report  |          45794 |             21 |         20.5 |          25
 Radiology         | Radiology report  |         522279 |              5 |          5.7 |          



Tokenizer evaluation: The stanford parser have been evaluated in several studies. The ctakes parser has a specialized
Myocardial infaction evaluation: Last but not least, this pipeline exploits two pipelines described above. It's evaluation thought a challenge testifies the approach works and might benefit from improvements.
All those NLP pipelines are interdependent. Improving one step would result in general improvement. Community work might apply here and subsequent result be used into cohort discovery or data-science feature extraction by analyst without prior knowledge in NLP. In order to be able to improve NLP results, an evaluation framework need to be built up. The NOTE_NLP table might be populated with gold standard manually annotated notes too.
While sections, sentences, and token are intermediary results, we believe that is is important to store them. This has several advantages: it helps text-miners. This has a severe drawback: the table becomes huge with potentially billions of rows POS tagging for each token.

Community sharing
===================

We provided many derived values. Community is welcome to improve it
- F/P, corrected Ca / K, BMI
- Note_NLP with section splitting. The algorythm is freely accessible here
- SOFA, SAPSII


others
######

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
