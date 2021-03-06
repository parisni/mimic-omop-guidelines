
Evaluation of OMOP as a CDM for the MIMICiii ICU database
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

# two way:
# way 1:
# - ICU research is crucial how to save lifes with data - many ICU database, not much open-source - multi-centric research is crucial
# - multicentric research approaches - OMOP appears to offer all in one - evaluate OMOP for ICU
# way 2:
# - Reasearch on MIMIC is crucial - MIMIC lacks of multicentric - MIMIC lacks of terminology and structure standardisation
# - multicentric research approaches - data standardisation approaches



ICU data : a paradox
####################
ICU has all of the expectation, because all kind of data...
- Reusing medical datas has historically been impossible for a large population
  and most of datas were simply wasted due data variability and quality
  challenges
- Intensive care unit ICU are faced to a paradox
        - The level of proof to guide most decisions is low, exacerbated with
          real-time bedsite decisions and the medical practices are sparse (1).
        - High density environment for data production : prescriptions systems,
          monitoring (waves), ventilators and large number of exams done in
          this units
- The practice's variability is due to lack of adherence to best practices, but
  the vast majority occurs simply because no evidence has been established for
  the issue in question (2) or because the effects of interventions in the ICU
  are subject to the exceptional complexity of patient physiology and the
  variation beetween unique patient and clinical studies
- But the ICU demand of care is rising (3) and the mortality in ICU is up to 30
  % which is a major health care problem (15)

=> How to save more lifes ?

General expectations of medical database
########################################
On the basis of Heterogeneous patient medical informations (clinical,
physiologic, genemomic, laboratory, imaging, reports, environement)
expectations are:
- to create complete and highly detailed patient records
- minimize costs while improving the clinical outcomes of individuals and
  populations thanks to observational clinical research and real time
  algorithms
- At international multicentric 
- Observational studies
- Adverse Event
- Drug/Drug Interaction
- Clinical research
- Personalized medecine 
- Medical Decision Guidance
- Early warning systems

Existing ICU databases
======================
Several commercial or noncommercial, opensource or nonopensource ICU databases have been developed

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

- Commercial eICU
	- developped in partenariat with Philips
	- available via PhysioNet
	- over 1.5 million ICU stays
	- and is adding 400,000 patient records per year from over 180 subscribing hospitals in the country. 
	- patients who were admitted to critical care units in 2014 and 2015.
	- Data are heterogenous and high granularity signal as waveform is not record

- Non commercial MIMICIII (Medical Information Mart for Intensive Care) : our case study
	- R. Marc
	- freely-available database via PhysioNet : https://mimic.physionet.org/
  	- A public github was created : https://github.com/MIT-LCP/mimic-code with many contributers around the world. 
	- Data are collected each 5 years, semi automatically. 
	- This database is de-identified and open, and anyone can exploit the data after passing an online exam on clinical ethic. 
	- over 300 publications from international researchers independant from the MIT
	- health-related data associated with over forty thousand patients who stayed in critical care units between 2001 and 2012(4).
	- It includes both administrative data (demographic, ICD9, procedures) and clinical data (examination, laboratory results, medication administration and notes)
	- Three types of data are collected : 
		- clinical data from hospital information system, 
		- death data from the social security database
		- High granulary data as the waveform of EKG, EEG: In this article we won't speak about high frequency datas. 

conclusion
==========
The MIMIC-III database is unique in capturing highly granular structured data.
But the conception of this database was time consuming and unfortunately only
45,000 unique patients' data from a single center were captured. 
To produce analyse high number of patient we will have to merge heterogenous
databases.

How research might be improved ?
- reproducibility (algorithm can be reused and shared) [AE paper] 
- readaptability (algorithm can be applied on other dataset)
- complexity (limiting the data processing, transformations to limit errors)
- share same concepts to be able to compare and improve care internationally
- share tools, packages, visualisation, practices and expertise

Data merging
############

aims
====
Use of EHRs has been increasing world-wide, but most EHRs are differents in their structure and not interchangeable.

- more data : may provide better outcomes
- interoperability may provide easy international research and improve reproductibily of it
- decrease costs and investment in developing algorithms and help to performs transferable analyses
- their data structure should be the closest to the EHR, to transfer easily research in real life
- data pipeline need to be the same to apply and confirm results accross multiple centers (algorithm performance)

challenges
==========
- but we know that simple merging of databases give poor quality level because of the heterogeneity of datas (9)
- but sharing data creates legal/juridic problems
- but merge may loss datas

=>  multicentric ?

Common Data Model: databases modelling and datas exchanges
==========================================================

As said Kahn and all, "databases modelling is the process of determining how data are to be stored in a database".
It specifies data types, constraints, relationship and metadata definitions.
Common data model (CDM) provides a standardized ways to represent resources/datas and their relationships.
The databases have been designed to facilitate exchanges and store data from multiple sources.
Several have been developed, some are open-source:
- MIMIC !
	- Even if MIMIC is a large, freely-available database, its datamodel does not provide easy sharing. 
	- Its structure is "ICU centric" with many relations created in this purpose (icustays, microbiology table).
	- Many terminologies used are american and are difficult to link to international classification
	- Many concepts are not link to international terminology (free text)
	- Moreover we need an international and common datamodel to put are algorithms in real life.

- I2B2 :
        - https://www.i2b2.org/
        - have been created as a framework to investigate genetic disease
	- good interface for cohort selection
	- i2b2 has been described as being used by more than 200 hospitals over the world
	- The central table is called observation_fact table
	- Compare to OMOP-CDM the hierarchies are organise with a 'concept path' column. Two concepts are linked by a single relationship                                
	
- FHIR, Fast Healthcare Interoperability Resources 
        - have been created to support healthcare uses of data like clinical decision support
	- is a standard for exchanging healthcare information electronically (https://www.hl7.org/fhir/overview.html/)
	- Some papers have showed that collaboration between FHIR  may provide both applicative software and analytic research and showed great promise(5, 13)
        - is not a relational model but a graph model (quite complexe relations between resources)

- PCORnet, the National Patient-Centered Clinical Research Network (http://pcornet.org/pcornet-common-data-model/)
        - have been created to monitore the safety of FDA-regulated medical products.
	- PCORnet Common Data Model (CDM) integrate multiple data from different sources and leverages standard terminologies and coding systems for healthcare (including ICD, SNOMED, CPT, HCPSC, and LOINC) to enable interoperability with and responsiveness to evolving data standards.
	- The first version of the CDM was released in 2014, and there have been 3 major releases and one minor update since then (last release CDM v4.1: Released May 18, 2018 )

- OMOP: Observational Medical Outcomes Partnership Common Data Model (OMOP-CDM) 
	- Incorpore validated standard classification (8) : SNOMED for diagnoses, RxNORM for drug ingredients and LOINC for laboratory results...
	- Provide tables for mapping beetween international classification (ex: ICD9 and SNOMED)
	- Public-private partnership as members of academics and industry are working on it
        - have been created to compare drug outcomes studies
	- In this model all the data stay locally at the participant site, the primary analyses are carried locally (5)
	- This model has been already adopted by more than 682 million patient records with databases from all over the world(9)
	- Several examples of transforming source databases to CDM already exists (10-11)

Sharing Protocole but not data model nor data
=============================================
The European project IMI PROTECT has demonstrated that CDM are not mandatory to
make multicentric analysis[16]. One of the major feedback it claims that
studies without CDM are more powerful in finding Adverse Event as compared to
OMOP.

Choice
======
Compared to PCORnet CDM, OMOP (6) :
- performes best in the evaluation database criteria compared with the other
  models (and PCORnet in particularly) : completeness, integrity, flexibility,
  simplicity of integration, and implementability.
- seems to accommodates the broadest coverage of standard terminologies.
- provides more systematic analysis with analytic library and visualizing tools
  from OMOP community : ACHILLES
- provides easier SQL models 
  
FHIR:
- does specify a common structural model
- does not specify a common terminology model, for most of the attributes
- has the descendent of HL7, it primary goal is data sharing at low granularity
  (eg: patient, device level)
- implementation may vary substancialy from one to other instance
- XML and JSON are both not optimized in a computational or user friendly to
  make queries
- API on production EHR are not able to export large amount of data while some
  work are in the process (FHIR bulk export)
- transformation from FHIR dataset to datascientist ready to process dataset
  may be one ETL per instance

OMOP shares the advantages of all above models. It allows local analysis with
raw values, and local terminologies as it stores. It adds values by using a
simple and common structural model. It allows standard analysis when needed,
and makes possible to compare. However, question still are:
- how transforming real datasets to OMOP is complicated
- how much dataset lose information
- how performances are affected 
- how well OMOP handle ICU database specificities

We limited the candidate data models to those designed and used for clinical
researches, and those freely available in the public domains without
restrictions.

Our study
###########

The aim of MIT with MIMIC-III is to provide open datas, more collaborative and
reproductitible studies with shared codes.  In this purpose the transformation
from MIMICIII to MIMICIII-OMOP with standardized mapping concept is important
and was hightly supported by the MIT. (4)

In this article we provide an example of Freely postgreSQL Extract Transform
Load (ELT) implementation of electronic health records (EHR) in intensive care
unit by transforming the all MIMIC-III database (expected high frequency datas)
to OMOP CDM version 5.3 (last version in date).  We’ll expose our methodology
and we’ll discuss about modification we want to propose to the omop community.
We’ll also discuss about potential loss of information links to this ETL.

This preliminary work is to transform the MIMIC DB into OMOP, and we evaluate
here OMOP in term of data merging (multicentric, observational, clinical)
Finally we will discuss how OMOP can address the early warning system challenge.

This work is evaluated through 3 axes: ETL, Analytics and Contribution.


Contributions
#############
The first major contribution of this study is to evaluate OMOP in a real life
and well known freely accessible database.
The second major contribution is to provide a freely accessible dataset in the
OMOP format that might be usefull for researchers.
The third major contribution is to provide the OMOP community some usefull
transformations dedicated to ICU and that can be reused in any OMOP dataset.


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
14. Kahn and Al. Data model considerations for clinical effectiveness researchers, Med Care, 2012
15. Azoulay E, Alberti C, Legendre I, Brun Buisson C, Le Gall J-R, for the European Sepsis Group Post-ICU mortality in critically ill infected patients: an international study. Intensive Care Med. 2005;31:56–63. doi: 10.1007/s00134-004-2532-x
16. Olaf H. Klungel et al. Multi-centre, multi-database studies with common protocols: lessons learnt from the IMI PROTECT project 2016



