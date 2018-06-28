-- chartevents
SELECT count(*) from mimiciii.chartevents where error is null or error = 0;
/*   count
-----------
 330579163
*/
SELECT count(*) from mimiciii.chartevents;
/*   count
-----------
 330712483

=> 99,9 %
*/

-- outputevents
SELECT count(*) from mimiciii.outputevents where iserror is null;
/*  count
---------
 4349218
*/
SELECT count(*) from mimiciii.outputevents;
/*  count
---------
 4349218

=> 100%
*/

-- inputevents_mv 
SELECT count(*) from inputevents_mv where cancelreason = 0;
/*
  count
---------
 3250366
*/

SELECT count(*) from inputevents_mv;
/*
count
---------
 3618991

=> 89%
 */

-- datetimeevents
 SELECT count(*) from mimiciii.datetimeevents where error = 1;
/*
  count
--------
   595
*/

SELECT count(*) from mimiciii.datetimeevents;
/*
  count
---------
 4485937

=> 100 %
*/

-- noteevents
SELECT count(*) from mimiciii.noteevents where iserror IS null;
/*
  count
---------
 2082294
 */

SELECT count(*) from mimiciii.noteevents;
/*
  count
---------
 2083180

=> 99,9 %
*/

-- procedureevents_mv
SELECT count(*) from mimiciii.procedureevents_mv where cancelreason = 0;
/*
 count
--------
 250284
 */

SELECT count(*) from mimiciii.procedureevents_mv;
/*
 count
--------
 258066

 => 96 %
 */
