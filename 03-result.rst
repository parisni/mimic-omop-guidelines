1. ETL
#######

The OMOP-CDM contains 37 data tables. We populated 19 tables.
From MIMICIII we create a standardized model called MIMICIII-OMOP.

Quality evaluation criteria
===========================
1)
Several articles tried to evaluate CDM quality (8, 9).
The criterias developped by Khan and Al, which referenced Moody and Shanks (10) metrics were adapted to our study.
Our study doesn't want to evaluate the quality of CDM. But we adapt these criterias to assess our ETL work.

| Data Model Dimension                          | Descriptions  |
|-----------------------------------------------|------------- |
| Completeness - structural mapping             | Data coverage : coverage of sources datas concepts that mapped to standard OMOP concept|
| Completeness - semantic mapping               | Domain coverage : coverage of sources domains that are accommodated by the standard OMOP model|
| Integrity                                     | "Meaningful data relationships and constraints that uphold th eintent of the data-s original purpose" Khan and Al |
| Flexibility                                   | The ease to expand the standard model for new datatypes, concepts |
| Integration                                   | The capacity of the standard model to use multiples terminology and links its to standard one|
| Implementability                              | The stability of the models, the comminity, the cost of adoption |
| Understandability                             | The ease of the standard model to be easily understood |
| Simplicity                                    | The ease of querying the standard model - the model should contains the minimum of concepts and relationship |

Understandability and simplicity will be evaluated in the analytics parts, in real life application.

2) 
During the all ETL process we created a lot of unit tests thanks to pgTap library. All are available on our github. All the test passed.

3)
A many previous authors, we used Achilles sofware to evaluate the data quality(4). It is open-source analytics software produced by OHDSI (6).
This tool is used for data characterization, data quality assessment (Achilles Heel), and the visualization of observational health data (6).
ACHILLES calculates summary statistics and includes a unique function for checking data quality, named Achilles Heel. 

Compleness - semantic mapping 
=============================
This following table shows where the informations goes and links between MIMICIII tables and MIMICIII-OMOP tables
As OMOP is a conceptual model, a same type of data goes in the same table. The best example may be the measurement table which is field by 4 source tables. Is is because of all the numerics datas should go to this table.

| Omop tables    	| Number of rows | Source tables |
|-----------------------|---------------|--------------|
| PERSONS 		| 46520         | patients, admissions |
| DEATH 		| 14849         | patients, admissions |
| VISIT_OCCURRENCE 	| 58976         | admissions |
| VISIT_DETAIL 		| 271808        | transfers, service |
| MEASUREMENT 		| 366272371     | chartevents, labevents, microbiologyevents, outputevents |
| OBSERVATION 		| 6721040       | admissions, chartevents, datetimevvents, drgcodes |
| DRUG_EXPOSURE 	| 24934758      | prescriptions, inputevents_cv, inputevents_mv|
| PROCEDURE_OCCURRENCE 	| 1063525       | cptevents, procedureevents_mv, procedure_icd|
| CONDITION_OCCURRENCE 	| 716595        | admissions, diagnosis_icd |
| NOTE 			| 2082294       | notevents|
| NOTE_NLP 		| 16350855      | noteevents |
| COHORT_ATTRIBUTE 	| 2628838       | callout |
| CARE_SITE 		| 93            | transfers, service |
| PROVIDER 		| 7567          | caregivers |
| OBSERVATION_PERIOD 	| 58976         | patients, admissions |
| SPECIMEN 	 	| 39874171      | chartevents, labevents, microbiologyevents |

Ajouter schema : MIMIC-OMOP_equivalence.png

As shown, all the MIMIC domain are links to proper OMOP domain. 
The semantic mapping was not a problem for our work.

Compleness - structural mapping 
===============================

Baseline characteristics : comparison MIMICIII / MIMIC OMOP (basic statistics)
******************************************************************************

The following table lists the baseline characterization of the population of MIMICIII-OMOP compared with MIMICIII.
The MIMIC-III database contains 45.520 individuals and 58.976 single admissions.

| items					|OMOP-MIMIC 			        | MIMICIII |
|---------------------------------------|---------------------------------------|----------|
| Persons (Number) 			| 46.520 			        | 46.520 |
| Admissions (Number) 			| 58.976 			        | 58.976 |
| Icustays (Number)   			| 61.532 			        | 71.576 |
| Gender, Female (Number, %) 	       	| 20.399 (43 %)               	        | 20.399 |
| Age (Mean)  				| 64 ans, 4 months 		        | 64 years, 4 months |
| 0-5  				        |   8110		                |   8110 |
| 6-15                                  |      1		                |      1 |
| 16-25			                |   1434		                |   1434 |
| 26-45  	                        |   5962		                |   5962 |
| 46-65				        |  17375		                |  17375 |
| 66-80				        |  15793		                |  15793 |
| >80				        |  10301		                |  10301 |
| Emergency                             |  42071	                        | 42071 |
| Elective		                |   7706                                | 7706 |
| Surgical patients		        | 19246 		                | 19246 |
| Length of stay, hospital (median) 	| 6.59 (Q1-Q3 : 3.84 - 11.88) 	        | 6.46 (Q1-Q3 : 3.74 -11.79) |
| Length of stay, ICU (median)      	| 1.87 (Q1-Q3 : 0.95 - 3.87)  	        | 2.09 (Q1-Q3 : 1.10 - 4.48) |
| Mortality, ICU (Number, %)        	| 5815 (9%)                   	        | 5814 (9%) |
| Mortality, hospital (Number, %)   	| 4559 (6%)                   	        | 4511 (7%) |
| Lab measurements per admissions (mean)| 678  (from labevents + charevents)    | 478 (from labevents) |
| Procedures per admissions (mean)      | 4.6                                   | 4.6 |
| Drugs per admissions (mean)           | 82.8                                  | 82.8 |
| Exit dignosis per admissions (mean)   | 11.0                                  | 11.0 |

MIMIC-III contains 61.532 stays in ICU whereas OMOP-MIMIC contains 71.576 unique stays.
That is a 116% increase in stays due to our ETL methodology as we explained in the methods.

We can see that we increase the number of laboratory measurement per admissions.
This is because the laboratory datas from chartevents has been extract and treated as laboratory
All the code to created this statistics are provided here (cf extra : basic_statistics.sql)

Loss of datas
*************
We tried to evaluate the percentage of loaded records from the source database to the OMOP-CDM
We evaluate the percentage of columns and the percentage of rows as have done other studies (1) 

- for the rows no data were lost. 
The error rows are deleted (inputevents_mv, chartevents, procedureevents_mv, note). As MIMIC team told us that they will remove it in the next release because this datas are poor quality we decided to do the same. 
The following table shows the number of rows with errors.
| Relations              | Error Percentage |
| inputevents_mv     | 10% |
| chartevents        | 0.04% |
| procedureevents_mv | 3% |
| Note               | 0.04% |

- Columns
Depending the tables between 40 % and 80% of sources columns which doesn't fits to CDM where erased. 
The exact removed columns are provided in the appendix (cf extras)
Almost all the removed columns are redundant with others or provide derived informations. 
The main concern could be the timestamp when the measurements contain a lot of it.
For example the chartevents MIMIC tables provide the storetime and charttime columns. 
The storetime was deleted during the ETL

terminology mapping coverage
****************************
| Omop tables (domain)  | Mapped_records | Total_records | % Mapped_records | Mapped_concepts_source | Total_concepts_source | % Mapped_concepts_source | Mapped_concept_id |
|-----------------------|----------------|---------------|------------------|------------------------|-----------------------|--------------------------|-------------------|
| PERSONS               | 93040          |         93040 |            100 % |                     43 |                    43 |                    100 % |                25 |
| VISIT_OCCURRENCE 	| 58976          |         58976 |            100 % |                     34 |                    34 |                    100 % |                19 |
| VISIT_DETAIL 		| 396930         |        396930 |            100 % |                     28 |                    28 |                    100 % |                17 |
| MEASUREMENT 		| 
| OBSERVATION 		| 
| DRUG_EXPOSURE 	| 9316670        |      24934751 |             37 % |                   3981 |                  7410 |                     53 % |              3555 |
| PROCEDURE_OCCURRENCE  | 1057914        |       1063525 |             99 % |                   2192 |                  2218 |                     98 % |              3406 |
| CONDITION_OCCURRENCE 	| 662799         |        716595 |             92 % |                   6647 |                  6984 |                     95 % |              6215 |
| CARE_SITE 		| 144            |           144 |            100 % |                     58 |                    58 |                    100 % |               105 |
| SPECIMEN 	 	| 28181686       |      39874171 |             70 % |                     71 |                    92 |                     77 % |                35 |

These results include automatic and manual mapping.

- The unmapped concept are the concept_id = 0 (No mapping concept). To improve this mapping we need collaborative work. We provide our csv mapping files on our github.
The terminology mapping has been evaluated by a physician. 

- % of domain_id not in adequation with table name 
	- some are logical because observation domain may be measurement table and vice verca

- we have mapped  many source concept to one standard concept_id. This is because MIMIC provide a lots of equivalent free text concepts.
  For example for the body temperature MIMIC provide 11 distinct concept (Temperature F, Temperature C (calc), Temp Skin [C], Temperature Fahrenheit, Temp Axillary [F], Temperature C, Temperature F (calc), Temperature Celsius, Temp Rectal [F], Temp Rectal, Blood Temperature CCO (C)). Our mapping links all of it to one single concept called temperature. All the units have been converted to celcius.

Flexibility  
===========
OMOP had a 100% match of the data models constraints and relationship.
Two important tables are provided with the OMOP models to  match relationship : concept_relationship and fact_relationship.
The fact_relationship table which is a important part of the OMOP CDM. It is used to represente the relationship between datas.
We used to link drugs in a solution, for  microbiology / antibiograms and for visit_detail and caresite.
The SQL following query shows how a microorganism is linked to its antibiogram thanks to fact_relationship

SELECT measurement_source_value, value_as_concept_id, concept_name
FROM measurement
JOIN concept resistance ON value_as_concept_id = concept_id
JOIN fact_relationship ON measurement_id =  fact_id_2
JOIN
(
	SELECT measurement_id AS id_is_staph
	FROM measurement m
	WHERE measurement_type_concept_id = 2000000007        			-- concept.concept_name = 'Labs - Culture Organisms'
	AND value_as_concept_id = 4149419                     			-- concept.concept_name = 'staph aureus coag +'
	AND measurement_concept_id = 46235217               			-- concept.concept_name = 'Bacteria identified in Blood product unit.autologous by Culture';

) staph ON id_is_staph = fact_id_1;
WHERE measurement_type_concept_id = 2000000008        			        -- concept.concept_name = 'Labs - Culture Sensitivity'


Integration
===========
- OMOP Terminology coverage has been previously evaluated as excellent(garza and al). We used the OMOP mapping for NDC-RxNorm, ICD9-SNOMED, CPT4-SNOMED.
- It was really helpful because MIMIC provide lots of non standard terminology already mapped by OMOP community
We tried to evaluated this OMOP mapping.
We check 100 items for each mapping used (NDC, ICD9 and CPT4). ICD9 and CPT4 are correcly mapped to SNOMED. But only 85% of NDC are
linked to a correct RxNorm code. In part due to incorrect NDC code (from MIMIC), in part because only 78% of NDC codes are mapped to Rxnorm.

But the OMOP common standard vocabulary, SNOMED-CT, did not cover all ICD-9-CM codes (95%). Moreover, not all ICD-9-CM codes can have one-to-one mapping to SNOMED, some are one-to-many (28%)(2)
 
Implementability
===============
- OMOP available since 9 years
- this models and its provided concepts are licence free
- the community is large and was very helpful.
- Full versions (V6, 7 etc.) are usually released each year (1-Jan) and are not backwards compatible. 
Minor versions (V5.1, 5.2 etc.) are not guaranteed to be backwards compatible though an effort is made to make sure that current queries will not break. 
Micro versions (V5.1.1, V5.1.2 etc.) are released irregularly and often, and contain small hot fixes or backward compatible changes to the last minor version.
(7)

Achilles for quality assessment
==============================
Other team used this tool to practice data quality assess(4).
Achilles Heel issued x errors and y warnings.

- 18h 50k patients: this testifies the model needs structural optimisations
- difficulté pour ajoute fr. 
- extension achilles how to ?
- comparison with other paper about error/warnings.

2 ANALYTICS
###########

Understandability and simplicity
================================
- OMOP is quite consise and simple model. 
The number of table joins 2-11. OMOP is quite a normalized model. We don't think it is a problem if we use materialized views as a solution (cf contribution section)
THis may help datascientists and statisticians to analyse datas
- standardized code

OMOP in real life
=================

Datathon
********
- French Paris hospital organized a datathon with MIMIC-OMOP
25 teams, 160 participants had 48 hours to undertake a clinical project using the OMOP MIMIC-III database throught 15000 requests. They had the opportunity to create mixed teams : clinicians brought the questions which need data mining, along with their expertise of the data ; data scientists judged the technical feasibility and eventually implement the various analysis needed
This datahon had tested OMOP model in real statistical condition. A datathon was organised in collaboration with the MIT.(3)

- AP-HP calculation clusters, able to access to the data pre-loaded in Jupyter environments, where will be installed the most popular tools and libraries in R and Python, with Hadoop Spark

schema big data platform

Dataforgood.fr
**************

ACHILLES for analytics assessment
================================
- datavisualisation
- cohort caracterisation

OMOP in real life
=================
- datathon
- dataforgood
- this work has been done with APHP to test OMOP model in real statistical condition. A datathon was organised in collaboration with the MIT.(3)
We also test the big data APHP platforms.

3 CONTRIBUTIONS
###############

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
- From noteevents : weight, heigth, LVEF
- From measurement : SOFA, IGSII, F/P, corrected Ca / K, BMI, corrected osmolarity

We also provided materialized views with denormalized structures : microbiology tables
This is a more ICU centric data structures that may help for analytics.

others
######

- estimation of number of work hours : Data transformation was done by 2 developers and praticians in 500 hours
- ethnicity_concept_id : only two strange concept_name hispanic or non_hispanic
- size of MIMIC OMOP, row number for the bigest relation (measurement)
- chartevents and labvents provide many number field as a string which is not handy for statistical analyse. We provide a standard and easy improval by the community model to extract numerical value from string
	- operators have been extracted to fill operator_concept_id column
	- numeric value has been extracted to fill value_as_number column
	- units of measures have been extracted to fill unit_concept_id column

1. F. FitzHenry Creating a Common Data Model for Comparative Effectiveness with the Observational Medical Outcomes Partnership. Appl Clin Inform 2015; 6: 536–547
2. https://www.nlm.nih.gov/research/umls/mapping_projects/icd9cm_to_snomedct.html
3. http://blogs.aphp.fr/dat-icu/
4. Y.Dukyong and Al, Conversion and Data Quality Assessment of Electronic Health Record Data at a Korean Tertiary Teaching Hospital to a Common Data Model for Distributed Network Research.Healthcare Informatics Research 2016; 54
6. https://www.ohdsi.org/analytic-tools/
7.https://github.com/OHDSI/CommonDataModel
8. Kahn and Al, Data Model Considerations for Clinical Effectiveness Researchers, Medical Care 07/2012, S60-S67
9. Garza and Al, Evaluating common data models for use with a longitudinal community registry, Journal of Biomedical Informatics 12/2016, 333-341
10. Moody and Shanks, Improving the quality of data models: empirical validation of a quality management framework, Information Systems 9/2003, 619-650
