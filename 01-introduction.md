# ICU datas : a paradox
- Reusing medical datas has historically been impossible for a large population and most of datas were simply wasted due data variability and quality challenges

- Intensive care unit ICU are faced to a paradox
	- The level of proof to guide most decisions is low, exacerbated with real-time bedsite decisions and the medical practices are sparse (1).
	- High density environment for data production : prescriptions systems, monitoring (waves), ventilators and large number of exams done in this units
 
- The practice’s variability is due to lack of adherence to best practices, but the vast majority occurs simply because no evidence has been established for the issue in question (2) or because the effects of interventions in the ICU are subject to the exceptional complexity of patient physiology and the variation beetween unique patient and clinical studies

- But the ICU demand of care is rising (3) and the mortality in ICU is up to 30 % which is a major health care problem

# ICU databases

## aim 
The multiple aims were
- to create complete and highly detailed patient record
- minimize costs while improving the clinical outcomes of individuals and populations thanks to observational clinical research and real time algorithms

## databases (7)
Several commercial or noncommercial, opensource or nonopensource ICU databases have been developed

- Commercial eICU
	- developped in partenariat with Philips
	- available via PhysioNet
	- over 1.5 million ICU stays
	- and is adding 400,000 patient records per year from over 180 subscribing hospitals in the country. 
	- patients who were admitted to critical care units in 2014 and 2015.
	- Data are heterogenous and high granularity signal as waveform is not record

- Non commercial CUB-REA database
	- B. Guidet, P. Aegerte
	- http://www.pifo.uvsq.fr/hebergement/cubrea/cr_index.htm
	- collected since 25 years around 300k ICU patients stays low granularity data from 30 distinct ICUs in Paris region.
	- Data are collected semi automatically annually
	- 15 international publications.

- Non commercial OutcomeREA database
	- JF Timsit
	- http://outcomerea.fr/index.php
	- collected since 20 years around 20k ICU patients stays medium granularity data from 20 distinct ICUs in France
	- Data are daily collected manually by senior trained intensivists,
	- This database has been subject of 50 publications.

- Non commercial MIMICIII (Medical Information Mart for Intensive Care) : our case study
	- R. Marc
	- freely-available database via PhysioNet : https://mimic.physionet.org/
	- Data are collected each 5 years, semi automatically. 
	- This database is de-identified and open, and one can exploit the data after passing an online exam on clinical ethic. 
	- over 300 publications from international researchers independant from the MIT
	- health-related data associated with over forty thousand patients who stayed in critical care units between 2001 and 2012(4).
	- It includes both administrative data (demographic, ICD9, procedures) and clinical data (examination, laboratory results, medication administration and notes)
	- Three types of data are collected : 
		- clinical data from hospital information system, 
		- death data from the social security database
		- High granulary data as the waveform of EKG, EEG.

## conclusion
The MIMIC-III database is unique in capturing highly granular structured data. But the conception of this database was time consuming and  unfortunately only 45,000 unique patients’ data from a single center were captured. 
To produce analyse high number of patient we will have to merge heterogenous databases.

# Data merging

## aims
Use of EHRs has been increasing world-wide, but most EHRs are different in their structure and not interchangeable.

- more data : may provide better outcomes
- interoperability may provide easy international research and improve reproductibily of it
- decrease costs and investment in developing algorithms and help to performs transferable analyses

## challenges
- but we know that simple merging of databases give poor quality level because of the heterogeneity of datas (9)
- but sharing data creates legal/juridic problems
- but merge may loss datas

## databases modelling and datas exchanges

Common data model (CDM) provides standardized definition of represent resources and their relationships.
Many has been developped, certains are open-source:
- OMOP model : Observational Medical Outcomes Partnership Common Data Model (OMOP-CDM) 
	- incorpore validated standard classification (8) : SNOMED for diagnoses, RxNORM for drug ingredients and LOINC for laboratory results...
	- provide tables for mapping beetween international classification (ex: ICD9 and SNOMED)
	- provides more systematic analysis with analytic library from OMOP community : ACHILLES

	- In this model all the data stay locally at the participant site, the primary analyses are carried locally (5)

	- This model has been already adopted by more than 682 million patient records with databases from all over the world(9)
	- Several examples of transforming source databases to CDM already exists (10-11)

- I2B2 :
	- good interface for cohort selection     
	- i2b2 has been described as being used by more than 200 hospitals6 over the world
	- The central table is called observation_fact table. 
	- Compare to OMOP-CDM the hierarchies are organise with a 'concept path' column. Two concepts are linked by a single relationship                                

- PCORnet, the National Patient-Centered Clinical Research Network [TODO APA]
	- PCORnet Common Data Model (CDM) hoping to integrate multiple data from different sources and leverages standard terminologies and coding systems for healthcare (including ICD, SNOMED, CPT, HCPSC, and LOINC) to enable interoperability with and responsiveness to evolving data standards.
	- The first version of the CDM was released in 2014
	- Compare to OMOP CDM, PCORNET is less effective for use with a longitudinal community registry (6)

- FHIR, Fast Healthcare Interoperability Resources 
	- is a standard for exchanging healthcare information electronically (https://www.hl7.org/fhir/overview.html)
	- Some papers have showed that collaboration between FHIR  may provide both applicative software and analytic research and showed great promise(5, 13) nico

- MIMIC !

OMOP choice Justification: [TODO APA] Terminology standardized, analytics tools tool available, SQL Model (Justifier VS NO-SQL). 

# Our study
The aim of MIT with MIMIC-III is to provide open datas, more collaborative and reproductitible studies with shared codes.
In this purpose the transformation from MIMICIII to MIMICIII-OMOP with standardized mapping concept is important and was hightly supported by the MIT. (4)

In this article we provide a example of Extract Transform Load (ELT) implementation of electronic health records (EHR) in intensive care unit by transforming the all MIMIC-III database (expected high frequency datas) to OMOP CDM version 5.3 (last version in date).
We’ll expose our methodology and we’ll discuss about modification we want to propose to the omop community.
We’ll also discuss about potential loss of information links to this ETL.

3 axes of evaluation : ETL, ANALITICS, Contribution.

1. Vincent JL. Is the current management of severe sepsis and septic shock
really evidence based? PLoS Med 2006; 3:e346
2. Vincent JL, Singer M. Critical care: advances and future perspectives.
Lancet 2010; 376:1354–1361
3. Angus DC, Kelley MA, Schmitz RJ, White A, Popovich J Jr; Committee on Manpower for Pulmonary and Critical Care Societies (COMPACCS). Caring for the critically ill patient. Current and projected workforce equirements for care of the critically ill and patients with pulmonary disease: can we meet the requirements of an aging population?
JAMA 2000;284:2762–2770
4. A.E.W. Johnson, Tom J. Pollard and Al. MIMIC-III, a freely accessible critical care database. Scientific Data. 2016-5-24
5. M. Choi and Al. OHDSI on FHIR Platform Development with OMOP CDM mapping to FHIR Resources,Georgia Tech Research Institute, poster
6. M.Garza. Evaluating common data models for use with a longitudinal community registry. Journal of Biomedical Informatics 2016. 333–341
7. Jeff Marshall, Abdullah Chahin and Barret Rush. Chapter 2 Review of Clinical Databases - Springer
8. JM Overhage and Al. Validation of a common data model for active safety surveillance research. J Am Med Inform Assoc. J Am Med Inform Assoc 2012;19: 54-60
9. G. Hripcsak and Al. Observational Health Data Sciences and Informatics (OHDSI): Opportunities for Observational Researchers.Stud Health Technol Inform. 2015 ; 216: 574–578
10. F. FitzHenry and Al. Creating a Common Data Model for Comparative Effectiveness with the Observational Medical Outcomes Partnership. Appl Clin Inform 2015; 6: 536–547
11. S. Bayzid and Al. Conversion of MIMIC to OHDSI CDM. National Center for Biomedical Communications, Bethesda, Maryland
12. T. Gruber. Toward principles for the design of ontologies used for knowledge sharing?, International journal of human-computer studies, 1995
13. Nicolas Paris and Al. i2b2 implemented over SMART-on-FHIR
