data source => intro
######################

- several other open-source databases
	- eICU (3), freely-available comprising deidentified with more than hundreds of thousands of patients. Data are available to researchers via PhysioNet, similar to the MIMIC database
	- OUTCOMEREA (http://outcomerea.fr/index.php)
	- CUBREA (http://www.pifo.uvsq.fr/hebergement/cubrea/cr_index.htm), with many ICU from APHP with > 2000000 icu stays

- presentation of mimicIII : our case study
  MIMIC-III (Medical Information Mart for Intensive Care) is freely-available database comprising deidentified 
  health-related data associated with over forty thousand patients who stayed in critical care units between 2001 and 2012(1).
  It includes both administrative data (demographic, ICD9, procedures) and clinical data (examination, laboratory results, medication administration and notes)
  Three types of data are collected : clinical data from hospital information system, death data from the social security database
  and the high granulary data as the waveform of EKG, EEG.
  In this article we won't speak about high frequency datas. 

  The aim of MIT with MIMIC-III is to provide open datas, more collaborative and reproductitible studies with shared codes. 
  MIMIC is a large used database with x number of publications.
  In this purpose the transformation from MIMICIII to MIMICIII-OMOP with standardized mapping concept is important.
  The mimic documentation is a available online physionet.org/about/mimic/. 
  A public github was created : https://github.com/MIT-LCP/mimic-code with many contributers around the world. 

# MIMIC and OMOP version
========================
- MIMIC III
- OHDSI CDM v 5.0.1 which defines 14 standardized clinical data tables, 5 health system data tables, 4 health economics data tables, 3 tables for derived elements and 8 tables for standardized vocabulary. 

ETL mapping specifications
#############################

- The key table for omop is the concept table. The standard vocabulary of OMOP is mainly based on the Systematized Nomenclature of Medicine Clinical Terms (SNOMED-CT)
- A mapping between many classification and the standard omop ones (ICD-9 and snomed-CT for examples) is already provides with concept_relationship.
- Local code for mimiciii such as admission diagnoses, demographic status, drugs, signs and symptoms were manually mapped to OMOP standard models by several participants. For example local drug codes were mapped to the OMOP standardized vocabularies, which use RxNorm. This work was followed and check by a physician. All laboratory exams, exit diagnoses and procedures were already mapped to standard classication. 
We had only use csv files for our manual mapping. All are available on github : https://github.com/MIT-LCP/mimic-omop/tree/master/extras/concept. This solution can scale for medical users without database engineering background. We tried to adopt the same methodology in their creation ; some obvious fields are needed : local and standard name, local and standard id and. Moreover evaluation and comments fields are good practices and may help contributers
- fuzzy match algorithm for mapping suggestion semi-automatic. [TODO: NPA]
The manual terminology mapping has been catalized by using a naïve but flexible approach. Many mapping tools exist on the area RELMA provided by LOINC, USAGI provided by OHDSI. Most of those tools are based on linguistic mapping [cite], and the approach have been shown to be the most effective[cite]. Following our prime idea to build low dependency tools, we managed to build a light semi-automatic tool based on postgresql full-text feature. The concept table labels have been indexed, and a similarity can be constructed by a simple sql query. We kept the 10 most similar concepts, and this have been shown to be a quick way to map concepts, after having choosen the best domain.
	
methodology of ETL
#####################

All the process is available freely on the github website : https://github.com/MIT-LCP/mimic-omop.

Preprocessing and modification of mimic
==========================================

- We added emergency stays as as a normal locations for patients throughout their hospital stay.
- Icustays mimic table was deleted as it is a derived table from transfers table (2) and we decided to assigne a new new visit_detail pour each stay in ICU (based of the transfers table) whereas mimic prefered to assgned new icustay stay if a new admissions occurs > 24h after the end of the previous stay
- We decided to put unique number for each row of mimic database  called mimic_id. We think this is very helpful for ETLers

 Technical specifications
============================

- To provide standard and reproductilable process all the ETL used SQL script.
- to speed up our work we used a subset of 100 patients
- unit testing during the all process of extraction and SQL script production

- we tried  not to infer results. For examens whereas it's logical to put a specimen for many labevents results (as one sample of blood may be used to multilple exams) we decided to create as many specimen row as laboratory exams because the information is not present. It was the same when date information were not provide ( start/end_datetime for drug_exposure)

- concept-driven methodology : as the omop model did we adopt a "concept-driven methodology", domain of each local concept drive the concept to the right table.

-mapping : omop model provide mapping between international classifications, such as gsn and rxnorm, icd9 and snomed thanks to concept_relationship table. We used it. 
Because drugs, chartevents, specimen, gender, ethnicity are not linked to concept in mimic, concepts has been mapped by medical doctors. We will evaluate this mapping in the result section.

- the fact_relationship table was used to link drugs in a solution, for  microbiology / antibiograms and forvisit_detail and caresite
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
 		- visit_detail/visit_occurrence : add admitting_source_value, admitting_source_concept_id, admitting_concept_id, discharge_to_source_value, discharge_to_source_concept_id, discharge_to_concept_id
               - drug_strength, drug_exposure, drug_era, dose_era: temporal columns.
               - note_nlp

	- conceptual (new concepts specific to ICU or general)
		- measurement_type_concept_id
		- the actual visit_detail doesn't introduce pertinent information and duplicate informations from visit_occurrence table. For admitting_from_concept_id and discharge_to_concept_id, we extended the dictionary in order to track bed transfers and ward transfers. For visit_type_concept_id we assigned a new concept for any level of granularity necessary for your use case (ward, bed...) 
		<!-- Fournir un example de visit_detail-->

- modification of MIMIC
	- visit_detail : admitting_source_value, admitting_source_concept_id, admitting_concept_id, discharge_to_source_value, discharge_to_source_concept_id, discharge_to_concept_id provide redondant information from visit_occurrence. We did't populate it.
	- observation_period provide duplicate information: we fill this table to respect the omop model and tools
	- operators have been extracted to fill operator_concept_id
	- units of measures have been extracted to fill unit_concept_id
	
1. A.E.W. Johnson, Tom J. Pollard and Al. MIMIC-III, a freely accessible critical care database. Scientific Data. 2016-5-24
2. https://mimic.physionet.org/mimictables/icustays/

Additional structural contributions
======================================

- era/analytics material views
	- To help datascientists we provide a denormalized models. We added concept_names everywhere for readibility
	- we also provide a materialized PostGreSql view for microbiology events. This provide a reorganise datas from measurement table for microorganism and related antibiograms.

- [TODO NPA] derived data pipelines: methods based on uima.
The note_nlp table allows to store NLP results derived from plain text notes. In order to evaluate this table we provided 3 pipelines based on apache UIMA [cite]
The first pipeline "section extractor" splits the notes into sections in order to help analysts to choose or avoid some sections from their analysis. The sections patterns (such "Illness History") have been automatically extracted from texts from regular expressions, automatically filtered by keeping only one with frequency higher than 1 percent and manually filtered to exclude false positives with a total of 1200 sections. The resulting sections patterns candidate have been then manually regrouped into similar 400 groups. 
The second pipeline "tokenizer pipeline" pre-splits sections into sentences and tokens. This allows analysts to simply get the tokens by splitting them by space character.
The third pipeline "n2c2 mi" extracts information about myocardial infarction. It states if is negated, from a family member, and tries to date that fact. The overall performance of the method has resulted into a 0.97 recall and 0.60 precision measured during the n2c2 challenge [cite]
The extracted sections have not been mapped to the any standard terminology such LOINC CDO. The reason is the CDO LOINC has decided to stop to maintain and to remove it's sections from its standard arguing it is too difficult to maintain, and this sections are not widely used [https://loinc.org/news/loinc-version-2-63-and-relma-version-6-22-are-now-available/].
