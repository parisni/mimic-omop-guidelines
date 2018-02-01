# Method

**quick presentation of mimicIII : our study case**

- presentation of mimicIII : our case study
  MIMIC-III (Medical Information Mart for Intensive Care) is freely-available database comprising deidentified 
  health-related data associated with over forty thousand patients who stayed in critical care units between 2001 and 2012(1).
  It includes both administrative data (demographic, ICD9, procedures) and clinical data (examination, laboratory results, medication administration and notes)
  Three types of data are collected : clinical data from hospital information system, death data from the social security database
  and the high granulary data as the waveform of EKG, EEG.
  In this article we won't speak about high frequency datas. 

  The aim of MIT with MIMIC-III is to provide open datas, more collaborative and reproductitible studies with shared codes. 
  In this purpose the transformation from MIMICIII to MIMIC-OMOP with standardized mapping concept is important.
  The mimic documentation is a available online physionet.org/about/mimic/. 
  A public github was created : https://github.com/MIT-LCP/mimic-code with many contributers around the world. 
 
- methodology of ETL and ETL mapping specifications
	- preprocessing of mimic : add emergency stays, unique number of all the database (mimic_id), dropping of icustays table which is a derived table from transfers and assignation of a new visit_detail pour each admission in ICU
	- technical (database, programming language, subset,  sequence, unit testing)
	- conceptual (concept mapping)
	- concept-driven methodology : the domain of each local concept drive the concept to the right table
	- try not to infer results : specimen for labevents, start/end_datetime for drug_exposure 
	- fact_relationship : for drug solution, microbiology / antibiograms, caresites / 

- modifications of OMOP model (few columns) 
	- structural (columns type, columns name, new columns)
		- visit_detail : adding of admitting_source_value, admitting_source_concept_id, admitting_concept_id, discharge_to_source_value, discharge_to_source_concept_id, discharge_to_concept_id
	- conceptual (new concepts specific to ICU or general)
		- measurement_type_concept_id
		- visit_detail_type_concept_id
                



1. A.E.W. Johnson, Tom J. Pollard and Al. MIMIC-III, a freely accessible critical care database. Scientific Data. 2016-5-24
