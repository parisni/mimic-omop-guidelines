/*
\copy 
(
WITH prescriptions_ndc as
(
	SELECT ndc, coalesce(drug, drug_name_poe, drug_name_generic, '') || ' ' || coalesce(prod_strength, '') as drug_name
	FROM mimiciii.prescriptions
	WHERE TRUE
	AND ndc is not null
	AND ndc != '0'
	LIMIT 200
)
,
ndc_to_concept_id AS
(
	SELECT concept_id, concept_name as concept_name_ndc, concept_code as ndc
	FROM concept
	WHERE TRUE
	AND domain_id = 'Drug'
	AND vocabulary_id = 'NDC'
)
,
rxnorm_to_concept_id AS
(
	SELECT concept_id_1 as concept_id, concept_name as concept_name_rxnorm
	From concept_relationship
	JOIN concept on concept_relationship.concept_id_2 = concept.concept_id
	WHERE concept_id_1 IN (
	SELECT concept_id FROM ndc_to_concept_id)
)
SELECT 
distinct drug_name as drug_name_prescriptions
, ndc
, concept_name_ndc
, concept_name_rxnorm
FROM prescriptions_ndc
LEFT JOIN ndc_to_concept_id USING (ndc)
LEFT JOIN rxnorm_to_concept_id USING (concept_id)
) 
to './paper_omop/extras/check_ndc_rxnorm_mapping.csv' DELIMITER ',' csv header; 						-- resultat = 100 lignes
																-- 15 lignes avec une erreur (soit dans le ndc, soit car ndc non mappes)

SELECT count(*) From concept where vocabulary_id = 'NDC'; 									-- 679882
SELECT count(*) from concept_relationship where concept_id_2 IN (SELECT concept_id From concept where vocabulary_id = 'NDC');	-- 535068 ==>78 % des items NDC sont mappes en rxnorm
*/

/*
\copy 
(
WITH condition_occurrence as
(
	SELECT icd9_code 
	, CASE
        	WHEN ICD9_CODE LIKE 'E%' AND LENGTH(ICD9_CODE) > 4 THEN substring(ICD9_CODE, 1, 4) || '.' || substring(ICD9_CODE, 5)
        	WHEN ICD9_CODE LIKE 'E%' AND length(ICD9_CODE) = 4 THEN ICD9_CODE
        	WHEN ICD9_CODE NOT LIKE 'E%' AND length(ICD9_CODE) > 3 THEN substring(ICD9_CODE, 1, 3) || '.' || substring(ICD9_CODE, 4)
        	WHEN ICD9_CODE NOT LIKE 'E%' AND length(ICD9_CODE) = 3 THEN ICD9_CODE ELSE NULL
	   END concept_code		
	FROM mimiciii.diagnoses_icd
	LIMIT 100
)
,
icd_to_concept_id AS
(
	SELECT concept_id, concept_name as concept_name_icd, concept_code
	FROM concept
	WHERE TRUE
	AND vocabulary_id    = 'ICD9CM'
)
,
snomed_to_concept_id AS
(
	SELECT concept_id_1 as concept_id, concept_id as concept_id_snomed, concept_name as concept_name_snomed
	From concept_relationship
	JOIN concept on concept_relationship.concept_id_2 = concept.concept_id
	WHERE concept_id_1 IN (
	SELECT concept_id FROM icd_to_concept_id)
	AND relationship_id = 'Maps to'
)
SELECT 
distinct icd9_code
, concept_code
, concept_id as concept_id_icd
, concept_name_icd
, concept_id_snomed
, concept_name_snomed
FROM condition_occurrence
LEFT JOIN icd_to_concept_id USING (concept_code)
LEFT JOIN snomed_to_concept_id USING (concept_id)
) 
to './paper_omop/extras/check_icd9_snomed_mapping.csv' DELIMITER ',' csv header; 						-- resultat = 85 lignes
																-- 0 erreurs

SELECT count(*) From concept where vocabulary_id = 'ICD9CM';									-- 18672
SELECT count(*) from concept_relationship where concept_id_2 IN (SELECT concept_id From concept where vocabulary_id = 'ICD9CM'); -- 70771
*/
