DROP function if exists mapping_evaluation(tables text, concept_column text, source_column text); 
CREATE OR REPLACE FUNCTION mapping_evaluation(tables text, concept_column text, source_column text)
  RETURNS table (MAPPED_records bigint, TOTAL_records bigint, percent_MAPPED_records bigint
	, MAPPED_concepts_source bigint, TOTAL_concepts_source bigint, percent_MAPPED_concepts bigint, MAPPED_concept_id bigint)
AS
$body$
BEGIN
      RETURN query EXECUTE format('
WITH mapped AS
(
	SELECT 1 as linker, count(*) as MAPPED_records, count(distinct %2$s) as MAPPED_concept_id, count(distinct %3$s) as MAPPED_concept_source
	FROM %1$s
	WHERE %2$s != 0
)
,
unmapped AS
(

	SELECT 1 AS linker, count(*) as UNMAPPED_records, count(distinct %3$s) as UNMAPPED_concept_source
	FROM %1$s
	WHERE %2$s = 0
)
SELECT 
MAPPED_records, (UNMAPPED_records + MAPPED_records) as TOTAL_records, MAPPED_records * 100 / (UNMAPPED_records + MAPPED_records) as percent_MAPPED_records
, MAPPED_concept_source, (UNMAPPED_concept_source + MAPPED_concept_source) as total_concepts, MAPPED_concept_source * 100 / (MAPPED_concept_source + UNMAPPED_concept_source) as percent_MAPPED_concepts
, MAPPED_concept_id
FROM mapped
JOIN unmapped USING (linker)', tables, concept_column, source_column);
END
$body$ 
LANGUAGE plpgsql;


SELECT '' as person_gender;
SELECT * FROM mapping_evaluation('person', 'gender_concept_id', 'gender_source_value');
SELECT '' as person_race;
SELECT * FROM mapping_evaluation('person', 'race_concept_id', 'race_source_value');

SELECT '' as visit_occurrence;
SELECT * FROM mapping_evaluation('visit_occurrence', 'visit_concept_id', 'visit_source_value');
SELECT * FROM mapping_evaluation('visit_occurrence', 'admitting_concept_id', 'admitting_source_value');
SELECT * FROM mapping_evaluation('visit_occurrence', 'discharge_to_concept_id', 'discharge_to_source_value');

SELECT '' as visit_detail;
-- division par zero var visit_source_value est null
SELECT * FROM mapping_evaluation('visit_detail', 'visit_detail_concept_id', 'visit_source_value');
SELECT * FROM mapping_evaluation('visit_detail', 'admitting_concept_id', 'admitting_source_value');
SELECT * FROM mapping_evaluation('visit_detail', 'discharge_to_concept_id', 'discharge_to_source_value');

SELECT '' as drug_exposure;
SELECT * FROM mapping_evaluation('drug_exposure', 'drug_concept_id', 'drug_source_value');

SELECT '' as procedure_occurrence;
SELECT * FROM mapping_evaluation('procedure_occurrence', 'procedure_concept_id', 'procedure_source_value');

SELECT '' as condition_occurrence;
SELECT * FROM mapping_evaluation('condition_occurrence', 'condition_concept_id', 'condition_source_concept_id');

/*
SELECT '' as measurement;
SELECT * FROM mapping_evaluation('measurement', 'measurement_concept_id', 'measurement_source_concept_id');
SELECT * FROM mapping_evaluation('measurement', 'measurement_concept_id', 'measurement_source_value');
*/

SELECT '' as care_site;
SELECT * FROM mapping_evaluation('care_site', 'care_site_id', 'care_site_source_value');
SELECT * FROM mapping_evaluation('care_site', 'place_of_service_concept_id', 'place_of_service_source_value');

SELECT '' as specimen;
SELECT * FROM mapping_evaluation('specimen', 'specimen_concept_id', 'specimen_source_value');

SELECT '' as observation;
WITH 
MAPPED_admissions AS
(
	SELECT 1 as linker
	, count(*) AS MAPPED_records
	, count(distinct observation_concept_id) AS MAPPED_concept_id
	, count(distinct observation_concept_id) AS MAPPED_concept_source
	FROM omop.observation
	WHERE observation_type_concept_id = 38000280 
	AND observation_concept_id NOT IN (4296248, 4085802) -- Cost containment, referred by nurse
	AND observation_concept_id != 0
),
UNMAPPED_admissions AS
(
	SELECT 1 as linker
	, count(*) AS UNMAPPED_records
	, 0 AS UNMAPPED_concept_source
	FROM omop.observation
	WHERE observation_type_concept_id = 38000280 
	AND observation_concept_id NOT IN (4296248, 4085802) -- Cost containment, referred by nurse
	AND observation_concept_id = 0
),
total_admissions AS
(
	SELECT 
	MAPPED_records, (UNMAPPED_records + MAPPED_records) as TOTAL_records
	, MAPPED_concept_source, (UNMAPPED_concept_source + MAPPED_concept_source) as total_concepts
	, MAPPED_concept_id
	FROM mapped_admissions
	JOIN unmapped_admissions USING (linker)
),
MAPPED_drgcodes AS
(
	SELECT 1 as linker
	, count(*) AS MAPPED_records
	, count(distinct value_as_concept_id) AS MAPPED_concept_id
	, count(distinct value_as_string) AS MAPPED_concept_source
	FROM omop.observation
	WHERE observation_concept_id = 4296248 
	AND value_as_concept_Id != 0
),
UNMAPPED_drgcodes AS
(
	SELECT 1 as linker
	, count(*) AS UNMAPPED_records
	, count(distinct value_as_string) AS UNMAPPED_concept_source
	FROM omop.observation
	WHERE observation_concept_id = 4296248
	AND value_as_concept_Id = 0
),
total_drgcodes AS
(
	SELECT 
	MAPPED_records, (UNMAPPED_records + MAPPED_records) as TOTAL_records
	, MAPPED_concept_source, (UNMAPPED_concept_source + MAPPED_concept_source) as total_concepts
	, MAPPED_concept_id
	FROM mapped_drgcodes
	JOIN unmapped_drgcodes USING (linker)
),

mapped_chartevents AS
(
        SELECT 1 as linker
	, count(*) as MAPPED_records
	, count(distinct observation_concept_id) as MAPPED_concept_id
	, count(distinct observation_source_concept_id) as MAPPED_concept_source
        FROM omop.observation
	WHERE observation_type_concept_id = 581413 
        AND observation_concept_id != 0
)
,
unmapped_chartevents AS
(

        SELECT 1 AS linker, count(*) as UNMAPPED_records, count(distinct observation_source_concept_id) as UNMAPPED_concept_source
        FROM omop.observation
	WHERE observation_type_concept_id = 581413 
        AND observation_concept_id = 0
),
total_chartevents AS
(
	SELECT
	MAPPED_records, (UNMAPPED_records + MAPPED_records) as TOTAL_records
	, MAPPED_concept_source, (UNMAPPED_concept_source + MAPPED_concept_source) as total_concepts
	, MAPPED_concept_id
	FROM mapped_chartevents
	JOIN unmapped_chartevents USING (linker)
),
total AS
(
	--SELECT * FROM total_datetimeevents
	--UNION
	SELECT * FROM total_admissions
	UNION
	SELECT * FROM total_drgcodes
	UNION
	SELECT * FROM total_chartevents
)
SELECT SUM(MAPPED_records) as MAPPED_records
, SUM(TOTAL_records) AS TOTAL_records
, SUM(MAPPED_records) * 100 / SUM(TOTAL_records) as percent_MAPPED_records
, SUM(MAPPED_concept_source) AS MAPPED_concept_source
, SUM(total_concepts) AS total_concepts
, SUM(MAPPED_concept_source) * 100 / SUM(total_concepts) as percent_MAPPED_concepts
, SUM(MAPPED_concept_id) AS MAPPED_concept_id
FROM total;
