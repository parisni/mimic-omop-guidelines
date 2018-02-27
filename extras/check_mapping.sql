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
