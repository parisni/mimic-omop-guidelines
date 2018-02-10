# Aim of standardisation
- Use of EHRs has been increasing world-wide, but most EHRs are different in their structure and not interchangeable.
	- multiple corpora, multiple languages
	- multiple use, multiple purpose (diagnosis, therapeutic, administrative record)
 
- more data and bigdata: may provide better outcomes
- interoperability may provide easy international research and improve reproductibily of it
- decrease costs and investment in developing algorithms and help to performs transferable analyses

- but we know that simple merging of databases give poor quality level because of the heterogeneity of datas
- but sharing data creates legal problems

# State of the art

## About medical classification system

A huge standardization effort has already been done to established number of classification systems.
The most known are the 
- International classification of disease developped by WHO
- Logical Observation Identifiers Names and Codes (LOINC), developed and distributed by  the  Regenstrief  Institute 
- Anatomical  Therapeutic  Chemical  (ATC)  classification  system  developed  by  WHO  Collaborating  Centre  for  Drug  Statistics  Methodology (WHOCC)
- Unified  Medical  Language  System  (UMLS) Metathesaurus  developed  by  the  United  States National Library  of  Medicine, and a part of it called RxNorm which is aclassification for drugs
- Systematized  Nomenclature  of  Medicine  Clinical  Terms  (SNOMED  CT), a work of the College of American Pathologists
- International Statistical Classification of Diseases and Related Health Problems (ICD) maintained by WHO

The coverage of this classifications is quite different because of the basis of their purpose (diagnosis, therapeutic, administrative..) and they don't solve the semantic heterogenicity in healthcare.
Ontology has been developped to provide more interoperability. It describes common vocabularies for researchers who need to share information in a domain. Reusing knowledge in new applications and to sharing  encoded knowledge across software environments is a major aim in deveopping this ontologies(10)

## About terminology mapping

Mappings try to provide correspondence between previous classifications. It may be performed manually or automatically.
Automatically mapping has been justified for adressing the purpose of scalability. Many technics has been proposed.

Sort of mapping:
- linguistic
- statistic
- infered from ontologies

## About databases modelling and datas exchanges

Common data model (CDM) provides standardized definition of represent resources and their relationships.
Many has been developped, certains are open-source:
- OMOP model : Observational Medical Outcomes Partnership Common Data Model (OMOP-CDM) incorpore validated standard classifation(4), and provides more systematic analysis with analytic library from OMOP community.
An important part of this model is the incorporation of common classifications that already exists :
SNOMED for diagnoses, RxNORM for drug ingredients and LOINC for laboratory results...
It provides both:
	- common database modeling
	- common terminology defined as standard

In this model all the data stay locally at the participant site, the primary analyses are carried locally.

This model has been already adopted by more than 682 million patient records with databases from all over the world(5)
Several examples of transforming source databases to CDM already exists (6-7). 

- I2B2 provides good interface for cohort selection. The central table is called observation_fact table. Compare to OMOP-CDM the hierarchies are organise with a 'concept path' column. Two concepts are linked by a single relationship

- PCORnet, the National Patient-Centered Clinical Research Network, is an opensource initiative of the Patient-Centered Outcomes Research Institute (PCORI)
PCORnet Common Data Model (CDM) hoping to integrate multiple data from different sources.
The first version of the CDM was released in 2014
Compare to OMOP CDM, PCORNET seems to be less effective for use with a longitudinal community registry (2)

Standards have been developped on electronic health  record communication
- FHIR, Fast Healthcare Interoperability Resources is a standard for exchanging healthcare information electronically (https://www.hl7.org/fhir/overview.html)
Some papers have showed that collaboration between FHIR  may provide both applicative software and analytic research and showed great promise(1)

# Our study

In this article we provide a example of Extract Transform Load (ELT) implementation of electronic health records (EHR) 
by transforming the all MIMIC-III database to OMOP CDM version 5.3 (last version in date). 
We’ll expose our methodology and we’ll discuss about modification we want to propose to the omop community.
We’ll also discuss about potential loss of information links to this ETL.


1. M. Choi and Al. OHDSI on FHIR Platform Development with OMOP CDM mapping to FHIR Resources,Georgia Tech Research Institute, poster
2. M.Garza. Evaluating common data models for use with a longitudinal community registry. Journal of Biomedical Informatics 2016. 333–341
3. Jeff Marshall, Abdullah Chahin and Barret Rush. Chapter 2 Review of Clinical Databases - Springer
4. JM Overhage and Al. Validation of a common data model for active safety surveillance research. J Am Med Inform Assoc. J Am Med Inform Assoc 2012;19: 54-60
5. G. Hripcsak and Al. Observational Health Data Sciences and Informatics (OHDSI): Opportunities for Observational Researchers.Stud Health Technol Inform. 2015 ; 216: 574–578
6. F. FitzHenry and Al. Creating a Common Data Model for Comparative Effectiveness with the Observational Medical Outcomes Partnership. Appl Clin Inform 2015; 6: 536–547
7. S. Bayzid and Al. Conversion of MIMIC to OHDSI CDM. National Center for Biomedical Communications, Bethesda, Maryland
10. T. Gruber. Toward principles for the design of ontologies used for knowledge sharing?, International journal of human-computer studies, 1995

Two articles (suggested by Christel) on conversion of Sniiram-like and EHR to OMOP:

8. You SC, Lee S, Cho SY, Park H, Jung S, Cho J, Yoon D, Park RW. Conversion of National Health Insurance Service-National Sample Cohort (NHIS-NSC) Database into Observational Medical Outcomes Partnership-Common Data Model (OMOP-CDM). Stud Health Technol Inform. 2017;245:467-470. PubMed PMID: 29295138.

9. Yoon D, Ahn EK, Park MY, Cho SY, Ryan P, Schuemie MJ, Shin D, Park H, Park RW. Conversion and Data Quality Assessment of Electronic Health Record Data at a Korean Tertiary Teaching Hospital to a Common Data Model for Distributed Network Research. Healthc Inform Res. 2016 Jan;22(1):54-8. doi: 10.4258/hir.2016.22.1.54. Epub 2016 Jan 31. PubMed PMID: 26893951; PubMed Central PMCID: PMC4756059.
