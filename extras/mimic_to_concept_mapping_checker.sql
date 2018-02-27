DROP function if exists map_concept(tables text, type_column text, concept_column text); 
CREATE OR REPLACE FUNCTION map_concept(tables text, type_column text, concept_column text)
  RETURNS table (concept_name text, unmapped int, total int, percentage_mapped numeric)
AS
$body$
BEGIN
      RETURN query EXECUTE format('
WITH non_mapped AS
(
	SELECT %2$s, count(*) as unmapped
	FROM %1$s
	WHERE %3$s = 0
	GROUP BY 1
)
,
mapped AS
(
	SELECT %2$s, count(*) as total
	FROM  %1$s
	GROUP BY 1
)
SELECT concept_name::text as type
, unmapped::int
, total::int
, (total - unmapped) * 100 / total::numeric as percentage_mappped
FROM mapped
JOIN non_mapped USING (%2$s)
JOIN concept ON %2$s = concept_id'
        , tables, type_column, concept_column);
END
$body$ 
LANGUAGE plpgsql;


-- ----------------------------------------------------------------------------------
-- DRUG_EXPOSURE
-- ----------------------------------------------------------------------------------

SELECT '' as drug_exposure;
SELECT * FROM map_concept('drug_exposure', 'drug_type_concept_id', 'drug_concept_id');

-- ----------------------------------------------------------------------------------
-- MEASUREMENT
-- ----------------------------------------------------------------------------------

SELECT '' as measurement;
SELECT * FROM map_concept('measurement', 'measurement_type_concept_id', 'measurement_concept_id');

-- ----------------------------------------------------------------------------------
-- SPECIMEN
-- ----------------------------------------------------------------------------------

SELECT '' as specimen;
SELECT * FROM map_concept('specimen', 'specimen_type_concept_id', 'specimen_concept_id');

-- ----------------------------------------------------------------------------------
-- SPECIMEN
-- ----------------------------------------------------------------------------------

SELECT '' as observation;
SELECT * FROM map_concept('observation', 'observation_type_concept_id', 'observation_concept_id');

-- ----------------------------------------------------------------------------------
-- PROCEDURE_OCCURRENCE
-- ----------------------------------------------------------------------------------

SELECT '' as procedure_occurrence;
SELECT * FROM map_concept('procedure_occurrence', 'procedure_type_concept_id', 'procedure_concept_id');

-- ----------------------------------------------------------------------------------
-- CONDITION_OCCURRENCE
-- ----------------------------------------------------------------------------------

SELECT '' as condition_occurrence;
SELECT * FROM map_concept('condition_occurrence', 'condition_type_concept_id', 'condition_concept_id');
