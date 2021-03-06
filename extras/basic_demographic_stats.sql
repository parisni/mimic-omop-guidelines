-- ----------------------------------------------------------------------------------
-- Patients number
-- ----------------------------------------------------------------------------------
-- mimiciii
SELECT COUNT(distinct subject_id) AS patients_mimic
FROM mimiciii.patients;

-- omop
SELECT COUNT(distinct person_id) AS patients_omop
FROM omop.person;

-- ----------------------------------------------------------------------------------
-- Admission number
-- ----------------------------------------------------------------------------------
-- mimiciii
SELECT COUNT(distinct hadm_id) AS adm_mimic
FROM mimiciii.admissions;

-- omop
SELECT COUNT(distinct visit_occurrence_id) AS adm_omop
FROM omop.visit_occurrence;


-- More tests
/*
-- mimiciii
SELECT COUNT(distinct subject_id)
FROM mimiciii.admissions;

-- omop
SELECT COUNT(distinct person_id)
FROM omop.person;
*/

-- ----------------------------------------------------------------------------------
-- ICU stays 
-- ----------------------------------------------------------------------------------

SELECT COUNT(distinct icustay_id) AS icustay_mimic
FROM mimiciii.icustays;

SELECT COUNT(distinct visit_detail_id) AS icustay_omop
FROM omop.visit_detail
WHERE visit_detail_concept_id = 581382                             -- concept.concept_name = 'Inpatient Intensive Care Facility'
AND visit_detail_type_concept_id = 2000000006;                            -- concept.concept_name = 'Ward and physical location'

-- More tests
 
-- mimiciii
SELECT COUNT(distinct subject_id), COUNT(distinct hadm_id)
FROM mimiciii.icustays;

-- omop
SELECT COUNT(distinct person_id), COUNT(distinct visit_occurrence_id)
FROM omop.visit_detail
WHERE visit_detail_concept_id = 581382                             -- concept.concept_name = 'Inpatient Intensive Care Facility'
AND visit_detail_type_concept_id = 2000000006;                            -- concept.concept_name = 'Ward and physical location'


-- ----------------------------------------------------------------------------------
-- AGE (mean at admission time)
-- ----------------------------------------------------------------------------------
-- mimiciii
WITH tmp AS
(
	SELECT AGE(admittime, dob) AS age 
	FROM mimiciii.admissions 
	LEFT JOIN mimiciii.patients USING (subject_id)
)
SELECT AVG(age) as age_mimic from tmp;

WITH tmp AS
(
	SELECT AGE(visit_start_datetime, birth_datetime) AS age 
	FROM omop.visit_occurrence
	LEFT JOIN omop.person USING (person_id)
)
SELECT AVG(age) as age_omop from tmp;

-- ----------------------------------------------------------------------------------
-- FEMALE
-- ----------------------------------------------------------------------------------
-- mimiciii
WITH tmp AS
(
	SELECT COUNT(distinct f.subject_id) AS female
	     , COUNT(distinct t.subject_id) AS total
	FROM mimiciii.patients t
	LEFT JOIN
	(
		SELECT subject_id
		FROM mimiciii.patients
		WHERE gender = 'F'
	) f USING (subject_id)
)
SELECT female AS female_mimic, total AS total_mimic, female * 100 / total AS female_percent_mimic FROM tmp;

-- omop
WITH tmp AS
(
	SELECT COUNT(distinct f.person_id) AS female
	     , COUNT(distinct t.person_id) AS total
	FROM omop.person t
	LEFT JOIN
	(
		SELECT person_id
		FROM omop.person
		WHERE GENDER_concept_id = 8532      -- concept.concept_name = 'FEMALE'
	) f USING (person_id)
)
SELECT female AS female_mimic, total AS total_omop, female * 100 / total as female_percent_omop FROM tmp;

-- ----------------------------------------------------------------------------------
-- hospital length of stays (LOS)
-- ----------------------------------------------------------------------------------
-- mimiciii
SELECT percentile_25 AS Q1_admlos_mimic
       , median AS median_admlos_mimic
       , percentile_75 AS Q3_admlos_mimic
       , MIN( EXTRACT(EPOCH FROM dischtime  - admittime)/60.0/60.0/24.0    )    AS minimum_admlos_mimic
       , MAX( EXTRACT(EPOCH FROM dischtime  - admittime)/60.0/60.0/24.0  )    AS maximum_admlos_mimic
       , CAST(AVG(  EXTRACT(EPOCH FROM dischtime  - admittime)/60.0/60.0/24.0  ) AS INTEGER)   AS mean_admlos_mimic
       , STDDEV( EXTRACT(EPOCH FROM dischtime  - admittime)/60.0/60.0/24.0    ) AS stddev_admlos_mimic
  FROM
  (SELECT MAX( CASE WHEN( percentile = 1    ) THEN los END    ) AS percentile_25
        , MAX( CASE WHEN( percentile = 2    ) THEN los END    ) AS median
        , MAX( CASE WHEN( percentile = 3    ) THEN los END    ) AS percentile_75
    FROM
       ( SELECT counter.los, counter.nb_los
              , FLOOR( CAST( SUM( nb_los    ) OVER( ORDER BY los ROWS UNBOUNDED PRECEDING    ) AS DECIMAL    )
                     / CAST( SUM( nb_los   ) OVER( ORDER BY los ROWS BETWEEN UNBOUNDED PRECEDING
                                                                        AND UNBOUNDED FOLLOWING    )  AS DECIMAL    )
                     * 4
                        ) + 1
          as percentile
          FROM
             ( SELECT EXTRACT(EPOCH FROM dischtime  - admittime )/60.0/60.0/24.0 as los, count(*) AS nb_los
                FROM mimiciii.admissions
                GROUP BY EXTRACT(EPOCH FROM dischtime  - admittime )/60.0/60.0/24.0
               ) as counter
         ) as p
     WHERE percentile <= 3
  ) as percentile_table, mimiciii.admissions
  GROUP BY percentile_25, median, percentile_75;

-- omop
SELECT percentile_25 AS Q1_admlos_omop
       , median AS median_admlos_omop
       , percentile_75 AS Q3_admlos_omop
       , MIN( EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0    )    AS minimum_admlos_omop
       , MAX( EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0  )    AS maximum_admlos_omop
       , CAST(AVG(  EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0  ) AS INTEGER)   AS mean_admlos_omop
       , STDDEV( EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0    ) AS stddev_admlos_omop
  FROM
  (SELECT MAX( CASE WHEN( percentile = 1    ) THEN los END    ) AS percentile_25
        , MAX( CASE WHEN( percentile = 2    ) THEN los END    ) AS median
        , MAX( CASE WHEN( percentile = 3    ) THEN los END    ) AS percentile_75
    FROM
       ( SELECT counter.los, counter.nb_los
              , FLOOR( CAST( SUM( nb_los    ) OVER( ORDER BY los ROWS UNBOUNDED PRECEDING    ) AS DECIMAL    )
                     / CAST( SUM( nb_los   ) OVER( ORDER BY los ROWS BETWEEN UNBOUNDED PRECEDING
                                                                        AND UNBOUNDED FOLLOWING    )  AS DECIMAL    )
                     * 4
                        ) + 1
          as percentile
          FROM
             ( SELECT EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0 as los, count(*) AS nb_los
                FROM omop.visit_occurrence
                GROUP BY EXTRACT(EPOCH FROM visit_end_datetime  - visit_start_datetime)/60.0/60.0/24.0
               ) as counter
         ) as p
     WHERE percentile <= 3
  ) as percentile_table, omop.visit_occurrence
  GROUP BY percentile_25, median, percentile_75;

-- ----------------------------------------------------------------------------------
-- Intensive Care Unit (ICU) LOS
-- ----------------------------------------------------------------------------------
-- mimiciii
SELECT percentile_25 AS Q1_iculos_mimic
       , median AS median_iculos_mimic
       , percentile_75 AS Q3_iculos_mimic
       , MIN( EXTRACT(EPOCH FROM outtime - intime )/60.0/60.0/24.0    )    AS minimum_iculos_mimic
       , MAX( EXTRACT(EPOCH FROM outtime - intime )/60.0/60.0/24.0  )    AS maximum_iculos_mimic
       , CAST(AVG(  EXTRACT(EPOCH FROM outtime - intime )/60.0/60.0/24.0  ) AS INTEGER)   AS mean_iculos_mimic
       , STDDEV( EXTRACT(EPOCH FROM outtime - intime )/60.0/60.0/24.0    ) AS stddev_iculos_mimic
  FROM
  (SELECT MAX( CASE WHEN( percentile = 1    ) THEN los END    ) AS percentile_25
        , MAX( CASE WHEN( percentile = 2    ) THEN los END    ) AS median
        , MAX( CASE WHEN( percentile = 3    ) THEN los END    ) AS percentile_75
    FROM
       ( SELECT counter.los, counter.nb_los
              , FLOOR( CAST( SUM( nb_los    ) OVER( ORDER BY los ROWS UNBOUNDED PRECEDING    ) AS DECIMAL    )
                     / CAST( SUM( nb_los   ) OVER( ORDER BY los ROWS BETWEEN UNBOUNDED PRECEDING
                                                                        AND UNBOUNDED FOLLOWING    )  AS DECIMAL    )
                     * 4
                        ) + 1
          as percentile
          FROM
             ( SELECT EXTRACT(EPOCH FROM outtime - intime )/60.0/60.0/24.0 as los, count(*) AS nb_los
                FROM mimiciii.icustays
                GROUP BY EXTRACT(EPOCH FROM outtime - intime )/60.0/60.0/24.0
               ) as counter
         ) as p
     WHERE percentile <= 3
  ) as percentile_table, mimiciii.icustays
  GROUP BY percentile_25, median, percentile_75;

-- omop
SELECT percentile_25 AS Q1_iculos_omop
       , median AS median_iculos_omop
       , percentile_75 AS Q3_iculos_omop
       , MIN( EXTRACT(EPOCH FROM visit_detail_end_datetime  - visit_detail_start_datetime)/60.0/60.0/24.0    )    AS minimum_iculos_omop
       , MAX( EXTRACT(EPOCH FROM visit_detail_end_datetime  - visit_detail_start_datetime)/60.0/60.0/24.0  )    AS maximum_iculos_omop
       , CAST(AVG(  EXTRACT(EPOCH FROM visit_detail_end_datetime  - visit_detail_start_datetime)/60.0/60.0/24.0  ) AS INTEGER)   AS mean_iculos_omop
       , STDDEV( EXTRACT(EPOCH FROM visit_detail_end_datetime  - visit_detail_start_datetime)/60.0/60.0/24.0    ) AS stddev_iculos_omop
  FROM
  (SELECT MAX( CASE WHEN( percentile = 1    ) THEN los END    ) AS percentile_25
        , MAX( CASE WHEN( percentile = 2    ) THEN los END    ) AS median
        , MAX( CASE WHEN( percentile = 3    ) THEN los END    ) AS percentile_75
    FROM
       ( SELECT counter.los, counter.nb_los
              , FLOOR( CAST( SUM( nb_los    ) OVER( ORDER BY los ROWS UNBOUNDED PRECEDING    ) AS DECIMAL    )
                     / CAST( SUM( nb_los   ) OVER( ORDER BY los ROWS BETWEEN UNBOUNDED PRECEDING
                                                                        AND UNBOUNDED FOLLOWING    )  AS DECIMAL    )
                     * 4
                        ) + 1
          as percentile
          FROM
             ( SELECT EXTRACT(EPOCH FROM visit_detail_end_datetime  - visit_detail_start_datetime)/60.0/60.0/24.0 as los, count(*) AS nb_los
                FROM omop.visit_detail
		WHERE visit_detail_concept_id = 581382               -- concept.concept_name = 'Inpatient Intensive Care Facility'
		AND visit_detail_type_concept_id = 2000000006               -- concept.concept_name = 'Ward and physical location'
                GROUP BY EXTRACT(EPOCH FROM visit_detail_end_datetime  - visit_detail_start_datetime)/60.0/60.0/24.0
               ) as counter
         ) as p
     WHERE percentile <= 3
  ) as percentile_table, omop.visit_detail
  WHERE visit_detail_concept_id = 581382                             -- concept.concept_name = 'Inpatient Intensive Care Facility'
  AND visit_detail_type_concept_id = 2000000006                             -- concept.concept_name = 'Ward and physical location'
  GROUP BY percentile_25, median, percentile_75;

-- ----------------------------------------------------------------------------------
-- hospital mortality
-- ----------------------------------------------------------------------------------
-- mimiciii
WITH tmp AS
(
	SELECT COUNT(distinct d.hadm_id) as dead
             , COUNT(distinct t.hadm_id) as total
	FROM mimiciii.admissions t
	LEFT JOIN
	(
		SELECT hadm_id
		FROM mimiciii.admissions
		WHERE hospital_expire_flag = 1
		AND diagnosis NOT ILIKE '%organ donor%'
	) d USING (hadm_id)
)
SELECT dead AS dead_hosp_mimic, total AS total_hosp_mimic, dead * 100 / total AS dead_percent_hosp_mimic FROM tmp;

-- omop
WITH tmp AS
(
  SELECT COUNT(distinct d.visit_occurrence_id) AS dead
       , COUNT(distinct t.visit_occurrence_id) AS total
  FROM omop.visit_occurrence t
  LEFT JOIN
  (
        SELECT visit_occurrence_id
        FROM omop.visit_occurrence
	WHERE discharge_to_concept_id = 4216643                     -- concept.concept_name = 'Patient died'
  ) d USING (visit_occurrence_id)
)
SELECT dead AS  dead_hosp_omop, total AS total_hosp_omop, dead * 100 / total AS dead_percent_hosp_omop FROM tmp;

-- ----------------------------------------------------------------------------------
-- ICU mortality
-- ----------------------------------------------------------------------------------
-- mimiciii
WITH tmp AS
(
	SELECT COUNT(distinct d.icustay_id) as dead
             , COUNT(distinct t.icustay_id) as total
	FROM mimiciii.icustays t
	LEFT JOIN
	(
		SELECT icustay_id
		FROM mimiciii.icustays icu
		LEFT JOIN mimiciii.admissions adm USING (hadm_id)
		WHERE adm.deathtime BETWEEN icu.intime AND icu.outtime
		and diagnosis NOT ILIKE '%organ donor%'
	) d USING (icustay_id)
)
SELECT dead AS dead_icu_mimic, total AS total_icu_mimic, dead * 100 / total AS dead_percent_icu_mimic FROM tmp;

-- omop
WITH tmp AS
(
  SELECT COUNT(distinct d.visit_detail_id) AS dead
       , COUNT(distinct t.visit_detail_id) AS total
  FROM omop.visit_detail t
  LEFT JOIN
  (
        SELECT visit_detail_id
        FROM omop.visit_detail
	WHERE visit_detail_concept_id = 581382                    -- concept.concept_name = 'Inpatient Intensive Care Facility'
	AND visit_detail_type_concept_id = 2000000006                    -- concept.concept_name = 'Ward and physical location'
	AND discharge_to_concept_id = 4216643                     -- concept.concept_name = 'Patient died'
  ) d USING (visit_detail_id)
  WHERE t.visit_detail_concept_id = 581382
  AND t.visit_detail_type_concept_id = 2000000006
)
SELECT dead AS  dead_icu_omop, total AS total_icu_omop, dead * 100 / total AS dead_percent_icu_omop FROM tmp;


-- ----------------------------------------------------------------------------------
-- AGE (mean at admission time)
-- https://my.vertica.com/docs/7.0.x/HTML/Content/Authoring/SQLReferenceManual/Functions/Mathematical/WIDTH_BUCKET.htm
-- ----------------------------------------------------------------------------------
-- mimiciii
WITH tmp AS
(
	SELECT EXTRACT(epoch FROM admittime -dob)/3600/24/365 AS age
	FROM mimiciii.admissions
	LEFT JOIN mimiciii.patients USING (subject_id)


),
bucket AS
(
	SELECT width_bucket(cast (age as numeric), 0, 100, 20) as age_bucket
	from tmp


),
readable AS
(
/*
Rmq: with width_bucket, if age < 0 => age_bucket == 0
                        if age between 0 et 5 => age_bucket == 1
			if age > 100 => age_bucket == 21
 1 2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 19 20  21
0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 100
*/
	SELECT
		CASE
			WHEN age_bucket <=1 THEN '0-5'
			WHEN age_bucket <=3 THEN '6-15'
			WHEN age_bucket <=5 THEN '16-25'
			WHEN age_bucket <=9 THEN '26-45'
			WHEN age_bucket <=13 THEN '45-65'
			WHEN age_bucket <=16 THEN '66-80'
			ELSE '>81'
			END AS age
	FROM bucket

)
SELECT age, count(*)
FROM readable
GROUP BY age
ORDER BY age;

--omop
WITH tmp AS
(
	SELECT EXTRACT(epoch FROM visit_start_datetime - birth_datetime)/3600/24/365 AS age
	FROM omop.visit_occurrence
	LEFT JOIN omop.person USING (person_id)

),
bucket AS
(
	SELECT width_bucket(cast (age as numeric), 0, 100, 20) as age_bucket
	from tmp

),
readable AS
(
/*
Rmq: with width_bucket, if age < 0 => age_bucket == 0
                        if age between 0 et 5 => age_bucket == 1
			if age > 100 => age_bucket == 21
 1 2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 19 20  21
0 5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 100
*/
	SELECT
		CASE
			WHEN age_bucket <=1 THEN '0-5'
			WHEN age_bucket <=3 THEN '6-15'
			WHEN age_bucket <=5 THEN '16-25'
			WHEN age_bucket <=9 THEN '26-45'
			WHEN age_bucket <=13 THEN '45-65'
			WHEN age_bucket <=16 THEN '66-80'
			ELSE '>81'
			END AS age
	FROM bucket

)
SELECT age, count(*)
FROM readable
GROUP BY age
ORDER BY age;

-- ----------------------------------------------------------------------------------
-- type_admission
-- ----------------------------------------------------------------------------------
-- mimiciii
SELECT admission_type, count(*) from mimiciii.admissions group by 1 order by 2 desc;

--omop
SELECT visit_source_value, visit_source_concept_id, count(*)
FROM visit_occurrence v
GROUP BY visit_source_value, visit_source_concept_id;

-- ----------------------------------------------------------------------------------
-- surgical_patient
-- ----------------------------------------------------------------------------------
-- mimic
WITH first_services AS
(
	SELECT hadm_id, min(transfertime) as transfertime
	FROM mimiciii.services
	-- WHERE prev_service is null
	Group by hadm_id

),
tmp AS
(
	SELECT curr_service
	FROM mimiciii.services s
	JOIN first_services fs
	ON s.hadm_id = fs.hadm_id
	AND s.transfertime = fs.transfertime

),
admission_type AS
(
	SELECT
		CASE
			WHEN curr_service IN ('CMED', 'MED', 'NMED', 'OMED') THEN 'General medical service'
			WHEN curr_service IN (
						'CSURG', 'DENT', 'ENT', 'GU', 'GYN'
						, 'NSURG', 'OBS', 'ORTHO', 'PSURG'
						, 'SURG', 'TRAUM', 'TSURG', 'VSURG'
					     
				) THEN 'Surgical service'
			WHEN curr_service IN ('NB', 'NBB') THEN 'Newborn care service'
			WHEN curr_service IN ('PSYCH') THEN 'Psychiatry service'
			ELSE NULL
			END AS concept_name
	FROM tmp

)
SELECT concept_name, count(*)
FROM admission_type
GROUP BY concept_name
ORDER BY count(*) DESC;

--omop
WITH first_services AS
(
	SELECT visit_occurrence_id, min(visit_start_datetime) AS visit_start_datetime
	FROM visit_detail
	WHERE visit_type_concept_id = 45770670
	group by visit_occurrence_id

),
tmp AS
(
	SELECT visit_detail_concept_id
	FROM visit_detail vd
	JOIN first_services fs
	ON fs.visit_occurrence_id = vd.visit_occurrence_id
	AND vd.visit_start_datetime = fs.visit_start_datetime
	AND vd.visit_type_concept_id = 45770670


)

SELECT concept_name, concept_id, count(1)
FROM tmp
JOIN concept ON visit_detail_concept_id = concept_id
GROUP BY 1, 2 ORDER BY count(1) desc;

-- -------------------------------------------------
-- procedures par admissions
-- ------------------------------------------------
-- mimic
WITH tmp AS
(
	SELECT hadm_id, count(*)
	FROM mimiciii.procedures_icd
	GROUP BY hadm_id

)
SELECT avg(count) AS mimic_procedures FROM tmp;

-- omop
WITH tmp AS
(
	SELECT visit_occurrence_id, count(*)
	FROM omop.procedure_occurrence
	WHERE procedure_type_concept_id = 38003622
	GROUP BY visit_occurrence_id

)
SELECT avg(count) AS omop_procedures FROM tmp;

-- -------------------------------------------------
-- diagnostics de sortie par admissions
-- ------------------------------------------------
-- mimic
WITH tmp AS
(
	SELECT hadm_id, count(*)
	FROM mimiciii.diagnoses_icd
	GROUP BY hadm_id

)
SELECT avg(count) AS mimic_diagnoses FROM tmp;

-- omop
WITH tmp AS
(
	SELECT visit_occurrence_id, count(*)
	FROM omop.condition_occurrence
	WHERE condition_type_concept_id != 42894222
	GROUP BY visit_occurrence_id

)
SELECT avg(count) AS omop_diagnoses FROM tmp;

-- -------------------------------------------------
-- drugs par admissions
-- ------------------------------------------------
-- mimic
WITH tmp AS
(
	SELECT hadm_id, count(*)
	FROM mimiciii.prescriptions
	GROUP BY hadm_id

)
SELECT avg(count) AS mimic_drugs FROM tmp;

-- omop
WITH tmp AS
(
	SELECT visit_occurrence_id, count(*)
	FROM omop.drug_exposure
	WHERE drug_type_concept_id = 38000177
	GROUP BY visit_occurrence_id

)
SELECT avg(count) AS omop_drugs FROM tmp;
