----------------------------------------------------------------------
-- drug_exposure
----------------------------------------------------------------------
SELECT count(*) from drug_exposure;
-- total : 24934758

SELECT count(*) from mimiciii.inputevents_mv where cancelreason = 0;
SELECT count(*) from mimiciii.inputevents_cv ;
SELECT count(*) from mimiciii.prescriptions ;
-- total : 24934751


----------------------------------------------------------------------
-- measurement
----------------------------------------------------------------------
-- chartevents
SELECT count(*) 
from mimiciii.chartevents c 
JOIN mimiciii.d_items d using (itemid) 
where category IN ( 'Labs', 'Blood Gases', 'Hematology', 'Heme/Coag', 'Coags', 'CSF', 'Enzymes','Chemistry');
-- tatal : 11661623

/*
SELECT min(c.mimic_id), max(c.mimic_id) 
from mimiciii.chartevents c 
JOIN mimiciii.d_items d using (itemid) 
where category IN ( 'Labs', 'Blood Gases', 'Hematology', 'Heme/Coag', 'Coags', 'CSF', 'Enzymes','Chemistry');
    min     |    max
------------+------------
 1117483946 | 1257744309
*/
SELECT count(*) from measurement where measurement_id BETween 1117483946 and 1257744309;
-- 139983077

-- labevents
SELECT count(*) from mimiciii.labevents;
-- total : 27854055
/*
SELECT min(mimic_id), max(mimic_id) from mimiciii.labevents ;
   min    |   max
----------+----------
 27145188 | 54999242
*/
SELECT count(*) from measurement where measurement_id BETWEEN 27145188 AND 54999242;
-- total : 27854055

-- check weight
SELECT count(*) from measurement where measurement_type_concept_id = 44818701 AND measurement_concept_id = 3025315;
-- total : 3729554
SELECT count(*) from mimiciii.inputevents_mv where patientweight is not null;
-- total : 3618991

-- check outputevent
SELECT count(*) from measurement where measurement_type_concept_id = 2000000003;
-- total : 4349218
SELECT count(*) from mimiciii.outputevents where iserror is null;
-- total : 4349218


----------------------------------------------------------------------
-- observation
----------------------------------------------------------------------
-- datetimeevents
SELECT count(*) from mimiciii.datetimeevents where error is null or error = 0; ;
-- total : 4485342
SELECT count(*) from observation where observation_concept_id = 4085802;
-- total : 4485342

-- insurance
SELECT count(*) from admissions where insurance is not null;
-- total 58976
SELECT count(*) from observation where observation_concept_id = 46235654;
-- total 58976

-- marital_status
SELECT count(*) from ad where marital_status  is not null;
-- total 48848
SELECT count(*) from observation where observation_concept_id = 40766231;
-- total 48848

-- language
SELECT count(*) from admissions where language   is not null;
-- total 33644
SELECT count(*) from observation where observation_concept_id = 40758030;
-- total 33644

-- ethnicity
SELECT count(*) from admissions where ethnicity    is not null        ;
-- total 58976
SELECT count(*) from observation where observation_concept_id = 44803968;
-- total 58976

-- religion
SELECT count(*) from mimiciii.admissions where religion is not null and religion NOT IN ('UNOBTAINABLE', 'OTHER', 'NOT SPECIFIED');
-- total 35717
SELECT count(*) from observation where observation_concept_id = 4052017;
-- total 35717

-- drgcodes
SELECT count(*) from mimiciii.drgcodes;
-- total : 125557
SELECT count(*) from observations where observation_concept_id = 4296248;
-- total : 125557

----------------------------------------------------------------------
-- providers
----------------------------------------------------------------------
SELECT count(*) from caregivers ;
-- total : 7567
SELECT count(*) from provider ;
-- total : 7567

----------------------------------------------------------------------
-- procedure_occurrence
----------------------------------------------------------------------
-- procedureevents_mv
SELECT count(*) FROM mimiciii.procedureevents_mv where cancelreason = 0;
-- total : 250284
SELECT count(*) from procedure_occurrence WHERE procedure_type_concept_id = 38000275;
-- total : 250284

-- procedures_icd
SELECT count(*) FROM mimiciii.procedures_icd;
-- total : 240095
SELECT count(*) from procedure_occurrence WHERE procedure_type_concept_id = 38003622;
-- total : 240095

-- cptevents
SELECT count(*) from procedure_occurrence where procedure_type_concept_id = 257;
-- total : 573146
SELECT count(*) FROM cptevents;
-- total :573146

----------------------------------------------------------------------
-- condition_occurrence
----------------------------------------------------------------------
-- diagnosis_icd
SELECT count(*) from mimiciii.diagnoses_icd where icd9_code is not null;
-- total : 651000
SELECT count(*) from condition_occurrence where condition_type_concept_id != 42894222;
-- total : 651000

-- admissions from admission (double mapping ! : one_to_many)
SELECT count(*) from admissions where diagnosis is not null;
-- total : 58951
SELECT count(*) from condition_occurrence where condition_type_concept_id = 42894222;
-- total : 65595

----------------------------------------------------------------------
-- note
----------------------------------------------------------------------
SELECT count(*) from noteevents iserror is null;
-- total : 2082294

SELECT count(*) from note;
-- total : 2082294
