# Remarks
- when a column is used for the jointure, keeped is yes
- row_id never used, because of mimic_id unique key

keeped :
- min : 20%
- max : 100%
- avg :

# ADMISSIONS 
|        Column        |              Type              | Modifiers| Keeped (yes/no/depend) | Derived values? (yes/no)|
|----------------------|--------------------------------|-----------|-----------------------|-------------------------|
| row_id               | integer                        | not null|n|n|
| subject_id           | integer                        | not null|y|n|
| hadm_id              | integer                        | not null|y|n|
| admittime            | timestamp(0) without time zone | not null|d|n|
| dischtime            | timestamp(0) without time zone | not null|y|n|
| deathtime            | timestamp(0) without time zone ||y|n|
| admission_type       | character varying(50)          | not null|y|n|
| admission_location   | character varying(50)          | not null|y|n|
| discharge_location   | character varying(50)          | not null|y|n|
| insurance            | character varying(255)         | not null|y|n|
| language             | character varying(10)          ||y|n|
| religion             | character varying(50)          ||y|n|
| marital_status       | character varying(50)          ||y|n|
| ethnicity            | character varying(200)         | not null|y|n|
| edregtime            | timestamp(0) without time zone ||d(when existing)|n|
| edouttime            | timestamp(0) without time zone ||d(when existing)|n|
| diagnosis            | character varying(255)         ||y|n|
| hospital_expire_flag | smallint                       ||n|y|
| has_chartevents_data | smallint                       | not null|n|y|

- if edregtime is not null, admittime is not keeped
- hospita_expire_flag and has_chartevens_data is derived

- keeped : 14/19 (70 %) 


# CALLOUT
|         Column         |              Type              | Modifiers  | Modifiers| Keeped (yes/no/depend) | Derived values? (yes/no)|
|------------------------|--------------------------------|------------|-----------------------------------|-------------------------|
| row_id                 | integer                        | not null|n|n|
| subject_id             | integer                        | not null|y|n|
| hadm_id                | integer                        | not null|y|n|
| submit_wardid          | integer                        ||n|n|
| submit_careunit        | character varying(15)          ||n|n|
| curr_wardid            | integer                        |y|n|
| curr_careunit          | character varying(15)          ||n|n|
| callout_wardid         | integer                        ||n|n|
| callout_service        | character varying(10)          | not null|n|n|
| request_tele           | smallint                       | not null|n|n|
| request_resp           | smallint                       | not null|n|n|
| request_cdiff          | smallint                       | not null|n|n|
| request_mrsa           | smallint                       | not null|n|n|
| request_vre            | smallint                       | not null|n|n|
| callout_status         | character varying(20)          | not null|n|n|
| callout_outcome        | character varying(20)          | not null|n|n|
| discharge_wardid       | integer                        ||n|n|
| acknowledge_status     | character varying(20)          | not null|n|n|
| createtime             | timestamp(0) without time zone | not null|y|n|
| updatetime             | timestamp(0) without time zone | not null|n|n|
| acknowledgetime        | timestamp(0) without time zone ||n|n|
| outcometime            | timestamp(0) without time zone | not null|y|n|
| firstreservationtime   | timestamp(0) without time zone ||n|n|
| currentreservationtime | timestamp(0) without time zone ||n|n|

- info for cohort_attribute (attribute_definition_id = 1)

- keeped : 5/24 (20 %)

# CAREGIVERS
|   Column    |         Type          | Modifiers | Keeped (yes/no/depend) | Derived values? (yes/no)|
|-------------|-----------------------|-----------|------------------------|-------------------------|
| row_id      | integer               | not null|n|n|
| cgid        | integer               | not null|n|n|
| label       | character varying(15) |y|n|
| description | character varying(30) |y|n|
 
- keeped 2/4 (50 %)


# CHARTEVENTS 
|    Column    |              Type              | Modifiers | Keeped (yes/no/depend) | Derived values? (yes/no)|
|--------------|--------------------------------|-----------|------------------------|-------------------------|
| row_id       | integer                        | not null|n|n|
| subject_id   | integer                        | not null|y|n|
| hadm_id      | integer                        ||y|n|
| icustay_id   | integer                        ||n|y|
| itemid       | integer                        ||y|n|
| charttime    | timestamp(0) without time zone ||y|n
| storetime    | timestamp(0) without time zone ||d(yes in measurement and specimen / no in observation)|n|
| cgid         | integer                        |y|n|
| value        | character varying(255)         |d(measurement or observation)|n|
| valuenum     | double precision               |y|n|
| valueuom     | character varying(50)          |y|n|
| warning      | integer                        |n|n|
| error        | integer                        |y|n|
| resultstatus | character varying(50)          |n|n|
| stopped      | character varying(50)          |n|n|

 - icustays_id never used because it's derived tables
 - storetime is lost for observation table
 - stopped, warning, resultstats are removed

- keeped : 9/15 (60 %)

# CPTEVENTS
|      Column      |              Type              |  Modifiers| Keeped (yes/no/depend) | Derived values? (yes/no)|
|------------------|--------------------------------|-----------|------------------------|-------------------------|
| row_id           | integer                        | not null|n|n|
| subject_id       | integer                        | not null|y|n|
| hadm_id          | integer                        | not null|y|n|
| costcenter       | character varying(10)          | not null|n|n|
| chartdate        | timestamp(0) without time zone ||y|n|
| cpt_cd           | character varying(10)          | not null|y|n|
| cpt_number       | integer                        ||n|y|
| cpt_suffix       | character varying(5)           ||n|y|
| ticket_id_seq    | integer                        ||n|y|
| sectionheader    | character varying(50)          |n|y|
| subsectionheader | character varying(255)         |y|n|
| description      | character varying(200)         ||n|y|

 - costcenter is removed
 - other removed columns are derived from cpt_cd

 - keeped : 5/12 (41 %)

# D_CPT
- not used

# D_ICD_DIAGNOSES
- not used

# D_ICD_PROCEDURES
|   Column    |          Type          | Modifiers| Keeped (yes/no/depend) | Derived values? (yes/no)|
|-------------|------------------------|----------|------------------------|-------------------------|
| row_id      | integer                | not null|n|n|
| icd9_code   | character varying(10)  | not null|y|n|
| short_title | character varying(50)  | not null|y|n|
| long_title  | character varying(255) | not null|y|n|

- all exempt row_id

# D_ITEMS
|    Column    |          Type          | Modifiers| Keeped (yes/no/depend) | Derived values? (yes/no)|
|--------------|------------------------|----------|------------------------|-------------------------|
| row_id       | integer                | not null|n|n|
| itemid       | integer                | not null|y|n|
| label        | character varying(200) ||y|n|
| abbreviation | character varying(100) ||y|n|
| dbsource     | character varying(20)  ||y|n|
| linksto      | character varying(50)  ||y|n|
| category     | character varying(100) ||y|n|
| unitname     | character varying(100) ||y|n|
| param_type   | character varying(30)  ||y|n|
| conceptid    | integer                ||n|n|

- all exempt row_id

# D_LABITEMS
|   Column   |          Type          | Modifiers| Keeped (yes/no/depend) | Derived values? (yes/no)|
|------------|------------------------|----------|------------------------|-------------------------|
| row_id     | integer                | not null|n|n|
| itemid     | integer                | not null|y|n|
| label      | character varying(100) | not null|y|n|
| fluid      | character varying(100) | not null|y|n|
| category   | character varying(100) | not null|y|n|
| loinc_code | character varying(100) ||y|n|

- all exempt row_id

# DATETIMEEVENTS
|    Column    |              Type              | Modifiers| Keeped (yes/no/depend) | Derived values? (yes/no)|
|--------------|--------------------------------|----------|------------------------|-------------------------|
| row_id       | integer                        | not null|n|n|
| subject_id   | integer                        | not null|y|n|
| hadm_id      | integer                        ||y|n|
| icustay_id   | integer                        ||n|y|
| itemid       | integer                        | not null|y|n|
| charttime    | timestamp(0) without time zone | not null|y|n|
| storetime    | timestamp(0) without time zone | not nulln|n|
| cgid         | integer                        | not null|y|n|
| value        | timestamp(0) without time zone ||d(si charttime is null)|n|
| valueuom     | character varying(50)          | not null|n|n|
| warning      | smallint                       ||n|n|
| error        | smallint                       ||y|n|
| resultstatus | character varying(50)          ||n|n|
| stopped      | character varying(50)          ||n|n|

 - keeped : 7/14 (50 %)

# DIAGNOSES_ICD
|   Column   |         Type          | Modifier| Keeped (yes/no/depend) | Derived values? (yes/no)|
|------------|-----------------------|---------|------------------------|-------------------------|
| row_id     | integer               | not null|n|n|
| subject_id | integer               | not null|y|n|
| hadm_id    | integer               | not null|y|n|
| seq_num    | integer               ||y|n|
| icd9_code  | character varying(10) ||y|n|

- all exempt row_id

# DRUGCODES
|    Column     |          Type          | Modifiers | Keeped (yes/no/depend) | Derived values? (yes/no)|
|---------------+------------------------+-----------|------------------------|-------------------------|
| row_id        | integer                | not null|n|n|
| subject_id    | integer                | not null|y|n|
| hadm_id       | integer                | not null|y|n|
| drg_type      | character varying(20)  | not null|n|y|
| drg_code      | character varying(20)  | not null|n|y|
| description   | character varying(255) ||y|n|
| drg_severity  | smallint               ||n|n|
| drg_mortality | smallint               ||n|n|

- keeped : 3 / 8 (40 %)

# ICUSTAYS
- not used

# INPUTEVENTS_CV
      Column       |              Type              | Modifiers | Keeped (yes/no/depend) | Derived values? (yes/no)|
-------------------+--------------------------------+-----------|------------------------|-------------------------|
 row_id            | integer                        | not null|n|n|
 subject_id        | integer                        | not null|y|n|
 hadm_id           | integer                        ||y|n|
 icustay_id        | integer                        ||n|y|
 charttime         | timestamp(0) without time zone ||y|n|
 itemid            | integer                        ||y|n|
 amount            | double precision               ||d|n|
 amountuom         | character varying(30)          ||d|n|
 rate              | double precision               ||d|n|
 rateuom           | character varying(30)          ||d|n|
 storetime         | timestamp(0) without time zone ||n|n|
 cgid              | integer                        ||y|n|
 orderid           | integer                        ||y|n|
 linkorderid       | integer                        ||y|n|
 stopped           | character varying(30)          ||y|n|
 newbottle         | integer                        ||n|n|
 originalamount    | double precision               ||n|n|
 originalamountuom | character varying(30)          ||n|n|
 originalroute     | character varying(30)          ||y|n|
 originalrate      | double precision               ||n|n|
 originalrateuom   | character varying(30)          ||n|n|
 originalsite      | character varying(30)          ||n|n|

- storetime not provide in OMOP

- keeped : 13 / 22 (59 %)

# INPUTEVENTS_MV
            Column             |              Type              | Modifiers | Keeped (yes/no/depend) | Derived values? (yes/no)|
-------------------------------+--------------------------------+-----------|------------------------|-------------------------|
 row_id                        | integer                        | not null|n|n|
 subject_id                    | integer                        | not null|y|n|
 hadm_id                       | integer                        ||y|n|
 icustay_id                    | integer                        ||n|y|
 starttime                     | timestamp(0) without time zone ||y|n|
 endtime                       | timestamp(0) without time zone ||y|n|
 itemid                        | integer                        ||y|n|
 amount                        | double precision               ||d|n|
 amountuom                     | character varying(30)          ||d|n|
 rate                          | double precision               ||d|n|
 rateuom                       | character varying(30)          ||d|n|
 storetime                     | timestamp(0) without time zone ||n|n|
 cgid                          | integer                        ||y|n|
 orderid                       | integer                        ||y|n|
 linkorderid                   | integer                        ||y|n|
 ordercategoryname             | character varying(100)         ||y|n|
 secondaryordercategoryname    | character varying(100)         ||n|n|
 ordercomponenttypedescription | character varying(200)         ||n|n|
 ordercategorydescription      | character varying(50)          ||y|n|
 patientweight                 | double precision               ||y|n|
 totalamount                   | double precision               ||n|y|
 totalamountuom                | character varying(50)          ||n|y|
 isopenbag                     | smallint                       ||n|n|
 continueinnextdept            | smallint                       ||n|n|
 cancelreason                  | smallint                       ||y|n|
 statusdescription             | character varying(30)          ||y|n|
 comments_editedby             | character varying(30)          ||n|n|
 comments_canceledby           | character varying(40)          ||n|n|
 comments_date                 | timestamp(0) without time zone ||n|n|
 originalamount                | double precision               ||n|n|
 originalrate                  | double precision               ||n|n|

- storetime not provide in OMOP

- keeped : 17 / 31 (54 %)

# LABEVENTS
   Column   |              Type              | Modifiers | Keeped (yes/no/depend) | Derived values? (yes/no)|
------------+--------------------------------+-----------|------------------------|-------------------------|
 row_id     | integer                        | not null|n|n|
 subject_id | integer                        | not null|y|n|
 hadm_id    | integer                        ||y|n|
 itemid     | integer                        | not null|y|n|
 charttime  | timestamp(0) without time zone ||y|n|
 value      | character varying(200)         ||y|n|
 valuenum   | double precision               ||n|n|
 valueuom   | character varying(20)          ||y|n|
 flag       | character varying(20)          ||n|n|

- keeped : 6/9 (66%)

# MICROBIOLOGYEVENTS
       Column        |              Type              | Modifiers | Keeped (yes/no/depend) | Derived values? (yes/no)|
---------------------+--------------------------------+-----------|------------------------|-------------------------|
 row_id              | integer                        | not null|n|n|
 subject_id          | integer                        | not null|y|n|
 hadm_id             | integer                        ||y|n|
 chartdate           | timestamp(0) without time zone ||d|n|
 charttime           | timestamp(0) without time zone ||y|n|
 spec_itemid         | integer                        ||y|n|
 spec_type_desc      | character varying(100)         ||y|n|
 org_itemid          | integer                        ||n|n|
 org_name            | character varying(100)         ||y|n|
 isolate_num         | smallint                       ||n|n|
 ab_itemid           | integer                        ||y|n|
 ab_name             | character varying(30)          ||y|n|
 dilution_text       | character varying(10)          ||y|n|
 dilution_comparison | character varying(20)          ||n|y|
 dilution_value      | double precision               ||n|y|
 interpretation      | character varying(5)           ||y|n|

- keeped : 11 / 16 (70 %)

# NOTEEVENTS
   Column    |              Type              | Modifiers | Keeped (yes/no/depend) | Derived values? (yes/no)|
-------------+--------------------------------+-----------|------------------------|-------------------------|
 row_id      | integer                        | not null|n|n|
 subject_id  | integer                        | not null|y|n|
 hadm_id     | integer                        ||y|n|
 chartdate   | timestamp(0) without time zone ||y|n|
 charttime   | timestamp(0) without time zone ||y|n|
 storetime   | timestamp(0) without time zone ||n|n|
 category    | character varying(50)          ||y|n|
 description | character varying(255)         ||y|n|
 cgid        | integer                        ||y|n|
 iserror     | character(1)                   ||y|n|
 text        | text                           ||y|n|

- storetime not provide in OMOP

- keeped : 9 / 11 (81 %)

# OUTPUTEVENTS
   Column   |              Type              | Modifiers | Keeped (yes/no/depend) | Derived values? (yes/no)|
------------+--------------------------------+-----------|------------------------|-------------------------|
 row_id     | integer                        | not null|n|n|
 subject_id | integer                        | not null|y|n|
 hadm_id    | integer                        ||y|n|
 icustay_id | integer                        ||n|y|
 charttime  | timestamp(0) without time zone ||y|n|
 itemid     | integer                        ||y|n|
 value      | double precision               ||y|n|
 valueuom   | character varying(30)          ||y|n|
 storetime  | timestamp(0) without time zone ||n|n|
 cgid       | integer                        ||y|n|
 stopped    | character varying(30)          ||n|n|
 newbottle  | character(1)                   ||n|n|
 iserror    | integer                        ||y|n|

- storetime not provide in OMOP

- keeped : 8 / 13 (61 %)

# PATIENTS
   Column    |              Type              | Modifiers | Keeped (yes/no/depend) | Derived values? (yes/no)|
-------------+--------------------------------+-----------|------------------------|-------------------------|
 row_id      | integer                        | not null|n|n|
 subject_id  | integer                        | not null|y|n|
 gender      | character varying(5)           | not null|y|n|
 dob         | timestamp(0) without time zone | not null|y|n|
 dod         | timestamp(0) without time zone ||n|n|
 dod_hosp    | timestamp(0) without time zone ||n|n|
 dod_ssn     | timestamp(0) without time zone ||y|n|
 expire_flag | integer                        | not null|n|y|

- rmq : dod and dod_hosp come from admission table

- keeped : 4 / 8 (50 %)

# PRESCRIPTIONS
      Column       |              Type              | Modifiers | Keeped (yes/no/depend) | Derived values? (yes/no)|
-------------------+--------------------------------+-----------|------------------------|-------------------------|
 row_id            | integer                        | not null|n|n|
 subject_id        | integer                        | not null|y|n|
 hadm_id           | integer                        | not null|y|n|
 icustay_id        | integer                        ||n|y|
 startdate         | timestamp(0) without time zone ||y|n|
 enddate           | timestamp(0) without time zone ||y|n|
 drug_type         | character varying(100)         | not null|y|n|
 drug              | character varying(100)         | not null|y|n|
 drug_name_poe     | character varying(100)         ||y|n|
 drug_name_generic | character varying(100)         ||y|n|
 formulary_drug_cd | character varying(120)         ||y|n|
 gsn               | character varying(200)         ||n|n|
 ndc               | character varying(120)         ||y|n|
 prod_strength     | character varying(120)         ||y|n|
 dose_val_rx       | character varying(120)         ||y|n|
 dose_unit_rx      | character varying(120)         ||y|n|
 form_val_disp     | character varying(120)         ||y|n|
 form_unit_disp    | character varying(120)         ||y|n|
 route             | character varying(120)         ||y|n|

- keeped : 16/19 (84%)

# PROCEDUREEVENTS_MV
           Column           |              Type              | Modifiers | Keeped (yes/no/depend) | Derived values? (yes/no)|
----------------------------+--------------------------------+-----------|------------------------|-------------------------|
 row_id                     | integer                        | not null|n|n|
 subject_id                 | integer                        | not null|y|n|
 hadm_id                    | integer                        | not null|y|n|
 icustay_id                 | integer                        ||n|n|
 starttime                  | timestamp(0) without time zone ||y|n|
 endtime                    | timestamp(0) without time zone ||n|n|
 itemid                     | integer                        ||y|n|
 value                      | double precision               ||y|n|
 valueuom                   | character varying(30)          ||n|n|
 location                   | character varying(30)          ||n|n|
 locationcategory           | character varying(30)          ||n|n|
 storetime                  | timestamp(0) without time zone ||n|n|
 cgid                       | integer                        ||y|n|
 orderid                    | integer                        ||n|n|
 linkorderid                | integer                        ||n|n|
 ordercategoryname          | character varying(100)         ||n|n|
 secondaryordercategoryname | character varying(100)         ||n|n|
 ordercategorydescription   | character varying(50)          ||n|n|
 isopenbag                  | smallint                       ||n|n|
 continueinnextdept         | smallint                       ||n|n|
 cancelreason               | smallint                       ||y|n|
 statusdescription          | character varying(30)          ||n|n|
 comments_editedby          | character varying(30)          ||n|n|
 comments_canceledby        | character varying(30)          ||n|n|
 comments_date              | timestamp(0) without time zone ||n|n|

- keeped : 7 / 25 (30%)


# PROCEDURES_ICD
   Column   |         Type          | Modifiers | Keeped (yes/no/depend) | Derived values? (yes/no)|
------------+-----------------------+-----------|------------------------|-------------------------|
 row_id     | integer               | not null|n|n|
 subject_id | integer               | not null|y|n|
 hadm_id    | integer               | not null|y|n|
 seq_num    | integer               | not null|n|n|
 icd9_code  | character varying(10) | not null|y|n|

- keeped : 3 / 5 (60%)

# SERVICES
    Column    |              Type              | Modifiers | Keeped (yes/no/depend) | Derived values? (yes/no)|
--------------+--------------------------------+-----------|------------------------|-------------------------|
 row_id       | integer                        | not null|n|n|
 subject_id   | integer                        | not null|y|n|
 hadm_id      | integer                        | not null|y|n|
 transfertime | timestamp(0) without time zone | not null|y|n|
 prev_service | character varying(20)          ||n|y|
 curr_service | character varying(20)          ||y|n|

- keeped : 4 / 6 (66%)

# TRANSFERS
   Column     |              Type              | Modifiers | Keeped (yes/no/depend) | Derived values? (yes/no)|
---------------+--------------------------------+----------|------------------------|-------------------------|-
 row_id        | integer                        | not null|n|n|
 subject_id    | integer                        | not null|y|n|
 hadm_id       | integer                        | not null|y|n|
 icustay_id    | integer                        ||n|n|
 dbsource      | character varying(20)          ||n|n|
 eventtype     | character varying(20)          ||y|n|
 prev_careunit | character varying(20)          ||n|y|
 curr_careunit | character varying(20)          ||y|n|
 prev_wardid   | smallint                       ||n|y|
 curr_wardid   | smallint                       ||y|n|
 intime        | timestamp(0) without time zone ||y|n|
 outtime       | timestamp(0) without time zone ||y|n|
 los           | double precision               ||n|y|

- keeped : 7 / 13 (53%)
