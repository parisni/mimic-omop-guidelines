SELECT count(*) from drug_exposure;
-- total : 24934758

SELECT count(*) from mimiciii.inputevents_mv where cancelreason = 0;
SELECT count(*) from mimiciii.inputevents_cv ;
SELECT count(*) from mimiciii.prescriptions ;
-- total : 24934751
