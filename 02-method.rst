MIMIC and OMOP version
========================
- MIMIC III version 1.4 21 clinical data tables and 5 tables for vocabulary
- OHDSI CDM v 5.0.1 which defines 15 standardized clinical data tables, 3 health system data tables, 2 health economics data tables, 5 tables for derived elements and 12 tables for standardized vocabulary. 
  We didn’t use the health economics data tables (not provided in MIMIC)

All the process is available freely on the github website : https://github.com/MIT-LCP/mimic-omop.

Ajouter les deux schemas de database design

1. ETL
#######

1.1 Data Transformation
+++++++++++++++++++++++

Extract-Transformation-Load (ETL) processes is a methodology that allow
migrating data from a source location to a target location. ETL first extract
the data from the source location, and then apply transformations such
structural modifications or conceptual modifications generaly on a dedicated
computer and technology. The last step is to load the resulting data into the
target location. Transformation program are generally written in a programming
language such java, c++ or python.
Extract-Load-Transform (ELT) processes is a slightly different methodology that
does not use a transformation server and limits data transfers. The data is
extracted and directly loaded into the target location. It is transformed
afterwards in place. ELT allows to factorize both computer resources, and
people knowledges. Indeed transformations are then written in a database
dialect such SQL, as well as source and target location. Improving database
resources will then benefit for both ETLers and end users. Since RDBMS computer
resources cannot scale well and does not provide a good support for procedural
language, ETL have been for long time used in conjonction with RDBMS. The
emmergence of distributed platform such hadoop allows to take part of ELT
because they both allow to scale well horizontally and write java procedural
user defined function that are used in conjonction with SQL queries.
In this work, we decided to transform MIMIC into OMOP thought a ELT to limit
the programming knowledges needed for code maintenance and to allow end users
to participate in this process. PostgreSQL has been choosen as the database
support for ELT because it allows community to run the ETL on limited resources
without licensing need. Finally PostgreSQL have recently made huge effort to
handle data-processing better.


Preprocessing and modification of mimic
==========================================

- constant dialogue with mimic community via MIMIC github
- We added emergency stays as a normal location for patients throughout their hospital stay.
- Icustays mimic table was deleted as it is a derived table from transfers table (2) and we decided to assigne a new new visit_detail pour each stay in ICU (based of the transfers table) whereas mimic prefered to assigne new icustay stay if a new admissions occurs > 24h after the end of the previous stay
- We decided to put unique number for each row of mimic database  called mimic_id. We think this is very helpful for ETLers

 Technical specifications
============================

- To provide standard and reproductilable process all the ETL used SQL script with PostgreSQL-ETL implementation
- to speed up our work we used a subset of 100 patients
- unit testing during the all process of extraction and SQL script production

- we tried  not to infer results. For examens whereas it's logical to put a specimen for many labevents results (as one sample of blood may be used to multilple exams) we decided to create as many specimen row as laboratory exams because the information is not present in MIMIC. It was the same when date information were not provide (start/end_datetime for drug_exposure)

- concept-driven methodology : as the omop model did we adopt a "concept-driven methodology", domain of each local concept drive the concept to the right table.

- the fact_relationship table was used to link drugs in a solution, for  microbiology / antibiograms and for visit_detail and caresite
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

modification of OMOP model
=============================

- the less possible
- keep in mind that OMOP is a conceptual model
- constant dialogue with omop community via OMOP github, ETL community (bresilian)

- modifications of OMOP model (few columns) 
	- structural (columns type, columns name, new columns)
 		- visit_detail/visit_occurrence proposal : add admitting_source_value, admitting_source_concept_id, admitting_concept_id, discharge_to_source_value, discharge_to_source_concept_id, discharge_to_concept_id
|Field                       |Type      |required|
|----------------------------|----------|---------|
|admitting_concept_id        | Integer  |  No     |
|admitting_source_value      | Varchar  |  No     |
|admitting_source_concept_id | Integer  |  No     |
|discharge_to_concept_id        | Integer  |  No     |
|discharge_to_source_value      | Varchar  |  No     |
|discharge_to_source_concept_id | Integer  |  No     |

               - note_nlp proposal
|Field                    |Type      |required|
|-------------------------|----------|---------|
|offset_begin             | Integer  |  No     |
|offset_end               | Integer  |  No     |
|section_source_value     | Text     |  No     |
|section_source_concept_id| Integer  |  No     |

	- conceptual (new concepts specific to ICU or general)
		- measurement_type_concept_id
		- the actual visit_detail doesn't introduce pertinent information and duplicate informations from visit_occurrence table. For admitting_from_concept_id and discharge_to_concept_id, we extended the dictionary in order to track bed transfers and ward transfers. For visit_type_concept_id we assigned a new concept for any level of granularity necessary for your use case (ward, bed...) 
		<!-- Fournir un example de visit_detail-->

- modification of MIMIC
	- visit_detail : admitting_source_value, admitting_source_concept_id, admitting_concept_id, discharge_to_source_value, discharge_to_source_concept_id, discharge_to_concept_id provide redondant information from visit_occurrence. We did't populate it.
	- observation_period provide duplicate informations with visit_occurrence : we fill this table to respect the omop model and tools
	- operators have been extracted to fill operator_concept_id
	- units of measures have been extracted to fill unit_concept_id
	- numeric values have been extracted to fill value_as_number
	
1. A.E.W. Johnson, Tom J. Pollard and Al. MIMIC-III, a freely accessible critical care database. Scientific Data. 2016-5-24
2. https://mimic.physionet.org/mimictables/icustays/

1.2 Terminology Mapping
++++++++++++++++++++++++

- The key table for omop is the concept table. The standard vocabulary of OMOP is mainly based on the Systematized Nomenclature of Medicine Clinical Terms (SNOMED-CT)
- A mapping between many classifications and the standard omop ones (ICD-9 and snomed-CT for examples) is already provides with concept_relationship table. We have used this to the maximum extent possible (laboratory exams, exit diagnoses and procedures)
  For the prescritions MIMIC-III table 75% (a verifier) of drugs had a gsn code. The conept_relationship table provide mapping between gsn and RxNorm classsifications. To improve the mapping we then proceeded to a manual mapping

- Local code for mimiciii such as admission diagnoses, demographic status, drugs, signs and symptoms were manually mapped to OMOP standard models by several participants. This work was followed and check by a physician. 
We had only used csv files for our manual mapping. All are available on github : https://github.com/MIT-LCP/mimic-omop/tree/master/extras/concept. This solution can scale for medical users without database engineering background. We tried to adopt the same methodology in their creation ; some obvious fields are needed : local and standard name, local and standard id. Moreover evaluation and comments fields are good practices and may help contributers
- fuzzy match algorithm for mapping suggestion semi-automatic.
The manual terminology mapping has been catalized by using a naïve but flexible approach. Many mapping tools exist on the area RELMA provided by LOINC, USAGI provided by OHDSI. Most of those tools are based on linguistic mapping [cite], and the approach have been shown to be the most effective[cite]. Following our prime idea to build low dependency tools, we managed to build a light semi-automatic tool based on postgresql full-text feature. The concept table labels have been indexed, and a similarity can be constructed by a simple sql query. We kept the 10 most similar concepts, and this have been shown to be a quick way to map concepts, after having choosen the best domain.
	

2. ANALYTICS
############

- datathon
- technical architechure
- organization


3. CONTRIBUTION
################

- era / analytics material views
	- To help datascientists we provide a denormalized models. We added concept_names everywhere for readibility
	- we also provide a materialized PostGreSql view for microbiology events. This provide a reorganised datas from measurement table for microorganism and related antibiograms. We think It can help researchers and datascientists

- derived data pipelines: methods based on uima.
The note_nlp table allows to store NLP results derived from plain text notes. In order to evaluate this table we provided 3 pipelines based on apache UIMA [cite]
The first pipeline "section extractor" splits the notes into sections in order to help analysts to choose or avoid some sections from their analysis. The sections patterns (such "Illness History") have been automatically extracted from texts from regular expressions, automatically filtered by keeping only one with frequency higher than 1 percent and manually filtered to exclude false positives with a total of 1200 sections. The resulting sections patterns candidate have been then manually regrouped into similar 400 groups. 
The second pipeline "tokenizer pipeline" pre-splits sections into sentences and tokens. This allows analysts to simply get the tokens by splitting them by space character and ease free text search.
The third pipeline "n2c2 mi" extracts information about myocardial infarction. It states if is negated, from a family member, and tries to date that fact. The overall performance of the method has resulted into a 0.97 recall and 0.60 precision measured during the n2c2 challenge [cite]
The extracted sections have not been mapped to the any standard terminology such LOINC CDO. The reason is the CDO LOINC has decided to stop to maintain and to remove it's sections from its standard arguing it is too difficult to maintain, and this sections are not widely used [https://loinc.org/news/loinc-version-2-63-and-relma-version-6-22-are-now-available/].
