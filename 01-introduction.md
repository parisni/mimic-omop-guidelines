# Introduction

**medical database merging: objectives**

- multiple corpora, multiple languages
- some normalized concepts (LOINC, ICD, ...) but 1. mapping can be improved and 2. other concepts are not normalized
- interoperability
- reproducilibity (through corpora, languages, etc.)
- more data: better outcomes
- decrease costs and investment in developing algorithms and help to performs transferable analyses


**medical database modelling - state of the art**

- i2b2
is an opensource common data model. The central table is called observation_fact table. 
I2B2 prrovides good interface for cohort selection. Compare to OMOP-CDM the hierarchies are organise with a 'concept path' column. Two concepts are linked by a single relationship
- fhir
FHIR,Fast Healthcare Interoperability Resources is a standard for exchanging healthcare information electronically (https://www.hl7.org/fhir/overview.html)
Some papers have showed that collaboration between FHIR  may provide both applicative software and analytic research and showed great promise(1)
- pcornet
PCORnet, the National Patient-Centered Clinical Research Network, is an opensource initiative of the Patient-Centered Outcomes Research Institute (PCORI)
PCORnet Common Data Model (CDM) hoping to integrate multiple data from different sources.
The first version of the CDM was released in 2014
Compare to OMOP CDM, PCORNET seems to be less effective for use with a longitudinal community registry (2)

Limits of this state

**terminology mapping - state of the art**

mapping:

- linguistic
- statistic
- infered from ontologies

**presentation of multiple ICU database**

Multiple ICU databases are already available.

- eICU (3), freely-availablecomprising deidentified with more than hundreds of thousands of patients. Data are available to researchers via PhysioNet, similar to the MIMIC database
- MIMIC,freely-available last release MIMIC-III
- OUTCOMEREA (http://outcomerea.fr/index.php)
- CUBREA (http://www.pifo.uvsq.fr/hebergement/cubrea/cr_index.htm), with many ICU from APHP with > 2000000 icu stays

**presentation of OMOP CDM**

Observational Medical Outcomes Partnership Common Data Model (OMOP-CDM) provides a common data structure.
With the use of  standard terminologies(4), this model provides more systematic analysis with analytic library from OMOP community.

This model has been already adopted by more than 682 million patient records with databases from all over the world(5)
An important part of this model is the mapping of various data vocabulary to common ontology that already exists : 
SNOMED for diagnoses, RxNORM for drug ingredients and LOINC for laboratory results. 

Several examples of transforming source databases to CDM already exists (6-7). 

In this article we provide a example of Extract Transform Load (ELT) implementation of electronic health records (EHR) 
by transforming the all MIMIC-III database to OMOP CDM version 5.3 (last version in date). 
We’ll expose our methodology and we’ll discuss about modification we want to propose to the omop community.
We’ll also discuss about potential loss of information links to this ETL.


**this work: improvement on both modelling and terminology mapping**

- omop provides both:
	- common database modeling
	- common terminology defined as standard



1. M. Choi and Al. OHDSI on FHIR Platform Development with OMOP CDM mapping to FHIR Resources,Georgia Tech Research Institute, poster
2. M.Garza. Evaluating common data models for use with a longitudinal community registry. Journal of Biomedical Informatics 2016. 333–341
3. Jeff Marshall, Abdullah Chahin and Barret Rush. Chapter 2 Review of Clinical Databases - Springer
4. JM Overhage and Al. Validation of a common data model for active safety surveillance research. J Am Med Inform Assoc. J Am Med Inform Assoc 2012;19: 54-60
5. G. Hripcsak and Al. Observational Health Data Sciences and Informatics (OHDSI): Opportunities for Observational Researchers.Stud Health Technol Inform. 2015 ; 216: 574–578
6. F. FitzHenry and Al. Creating a Common Data Model for Comparative Effectiveness with the Observational Medical Outcomes Partnership. Appl Clin Inform 2015; 6: 536–547
7. S. Bayzid and Al. Conversion of MIMIC to OHDSI CDM. National Center for Biomedical Communications, Bethesda, Maryland

Two articles (suggested by Christel) on conversion of Sniiram-like and EHR to OMOP:

7. You SC, Lee S, Cho SY, Park H, Jung S, Cho J, Yoon D, Park RW. Conversion of National Health Insurance Service-National Sample Cohort (NHIS-NSC) Database into Observational Medical Outcomes Partnership-Common Data Model (OMOP-CDM). Stud Health Technol Inform. 2017;245:467-470. PubMed PMID: 29295138.

8. Yoon D, Ahn EK, Park MY, Cho SY, Ryan P, Schuemie MJ, Shin D, Park H, Park RW. Conversion and Data Quality Assessment of Electronic Health Record Data at a Korean Tertiary Teaching Hospital to a Common Data Model for Distributed Network Research. Healthc Inform Res. 2016 Jan;22(1):54-8. doi: 10.4258/hir.2016.22.1.54. Epub 2016 Jan 31. PubMed PMID: 26893951; PubMed Central PMCID: PMC4756059.
