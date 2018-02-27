-- ----------------------------------------------------------------------------------
-- DRUG_EXPOSURE
-- ----------------------------------------------------------------------------------

SELECT '' as drug_exposure;

WITH non_mapped AS
(
	SELECT drug_type_concept_id, count(drug_exposure_id) as unmapped
	FROM drug_exposure
	WHERE drug_concept_id = 0
	GROUP BY drug_type_concept_id
)
,
mapped AS
(
	SELECT drug_type_concept_id, count(drug_exposure_id) as total
	FROM drug_exposure
	GROUP BY drug_type_concept_id
)

SELECT concept_name as type
, unmapped
, total
, unmapped * 100 / total as percentage_unmappped
FROM mapped
JOIN non_mapped USING (drug_type_concept_id)
JOIN concept ON drug_type_concept_id = concept_id
;
