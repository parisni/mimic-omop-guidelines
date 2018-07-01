SELECT count(*) from chartevents;
-- 330712483
SELECT count(*) from chartevents where error = 1;
-- 133320
-- 0.04%

SELECT count(*) from outputevents;
--4349218
SELECT COUNT(*) from outputevents where iserror is not null;
--0!

 SELECT count(*) from  inputevents_mv where cancelreason != 0;
 --368625
SELECT count(*) from  inputevents_mv;
-- 3618991
-- 10%


SELECT count(*) from procedureevents_mv  where cancelreason != 0;
--  7782
SELECT count(*) from procedureevents_mv;
-- 258066
--3%


SELECT count(*) from noteevents where iserror is not null ;
--   886
SELECT count(*) from noteevents;
-- 2083180
-- 0.04%
