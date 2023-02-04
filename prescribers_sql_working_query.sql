
--1.

-- a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
-- SELECT npi, SUM(total_claim_count) AS sum_total_claim_count
-- FROM prescriber
-- INNER JOIN prescription
-- USING (npi)
-- GROUP BY npi
-- ORDER BY sum_total_claim_count DESC;
--ANSWER: npi:1881634483; total_claim_count:99707
						   
-- b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, and the total number of claims.
-- SELECT npi, nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, SUM(total_claim_count) AS sum_total_claim_count
-- FROM prescriber 
-- INNER JOIN prescription
-- USING (npi)
-- GROUP BY npi, nppes_provider_first_name, nppes_provider_last_org_name, specialty_description
-- ORDER BY sum_total_claim_count DESC;
--ANSWER: 1881634483; "BRUCE" "PENDLEY"; "Family Practice"; 99707

--2.
-- a. Which specialty had the most total number of claims (totaled over all drugs)?
-- SELECT specialty_description, SUM(total_claim_count)
-- FROM prescriber
-- INNER JOIN prescription
-- USING (npi)
-- GROUP BY specialty_description
-- ORDER BY SUM(total_claim_count) DESC;
--ANSWER: Family Practice (9,752,347)

-- b. Which specialty had the most total number of claims for opioids?
-- SELECT specialty_description, SUM(total_claim_count)
-- FROM prescriber AS p1
-- INNER JOIN prescription AS p2
-- USING (npi)
-- INNER JOIN drug AS d
-- ON p2.drug_name = d.drug_name
-- WHERE opioid_drug_flag = 'Y'
-- GROUP BY specialty_description
-- ORDER BY SUM(total_claim_count) DESC;
--ANSWER: Nurse Practitioner (900,845)

-- c. Challenge Question: Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?
-- SELECT specialty_description
-- FROM prescriber
-- LEFT JOIN prescription
-- USING (npi)
-- GROUP BY specialty_description
-- HAVING COUNT(total_claim_count) = 0;
--ANSWER: 15

-- 3.
-- a. Which drug (generic_name) had the highest total drug cost?
-- SELECT generic_name, SUM(total_drug_cost) AS total_drug_cost
-- FROM prescription
-- INNER JOIN drug
-- USING (drug_name)
-- GROUP BY generic_name
-- ORDER BY total_drug_cost DESC;
--ANSWER: "INSULIN GLARGINE,HUM.REC.ANLOG" (104,264,066.35)

--b. Which drug (generic_name) has the hightest total cost per day? Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.
-- SELECT generic_name, total_30_day_fill_count, SUM(total_drug_cost) AS total_drug_cost, ROUND(SUM(total_drug_cost) / total_30_day_fill_count, 2) AS total_cost_per_day
-- FROM prescription
-- INNER JOIN drug
-- USING (drug_name)
-- GROUP BY generic_name, total_30_day_fill_count
-- ORDER BY total_cost_per_day DESC;
--ANSWER: "LEDIPASVIR/SOFOSBUVIR" ($319,593.25 per day)

-- 4.
-- a. For each drug in the drug table, return the drug name and then a column named 'drug_type' which says 'opioid' for drugs which have opioid_drug_flag = 'Y', says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.
-- SELECT DISTINCT drug_name,
-- 	CASE 
-- 		WHEN opioid_drug_flag = 'Y' THEN 'opioid'
-- 		WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- 		ELSE 'neither'
-- 	END AS drug_type
-- FROM drug;
--b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.
-- SELECT CASE 
-- 	WHEN opioid_drug_flag = 'Y' THEN 'opioid'
-- 	WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
-- 	ELSE 'neither'
-- END AS drug_type, SUM(p.total_drug_cost::MONEY) AS total_drug_cost
-- FROM prescription as p
-- LEFT JOIN drug AS d
-- USING (drug_name)
-- GROUP BY drug_type
-- ORDER BY total_drug_cost DESC;
-- ANSWER: Neither -- $2,972,698,710.23

-- 5. 
--a. How many CBSAs are in Tennessee? Warning: The cbsa table contains information for all states, not just Tennessee.
-- SELECT DISTINCT cbsa, cbsaname
-- FROM cbsa
-- INNER JOIN fips_county
-- USING (fipscounty)
-- WHERE state = 'TN';
--ANSWER: 10 in the state of TN

--b. Which cbsa has the largest combined population? Which has the smallest? Report the CBSA name and total population.
-- SELECT cbsa, SUM(population) as total_population
-- FROM population
-- LEFT JOIN cbsa
-- USING (fipscounty)
-- GROUP BY cbsa
-- ORDER BY total_population DESC
-- LIMIT 1;
--c. What is the largest (in terms of population) county which is not included in a CBSA? Report the county name and population.
-- SELECT p.population, fc.county
-- FROM population as p
-- LEFT JOIN fips_county as fc
-- 	ON p.fipscounty = fc.fipscounty
-- LEFT JOIN cbsa as c
-- 	ON c.fipscounty = fc.fipscounty
-- WHERE c.fipscounty IS NULL
-- ORDER BY p.population DESC;

-- 6.
-- a. Find all rows in the prescription table where total_claims is at least 3000. Report the drug_name and the total_claim_count.
-- SELECT *
-- FROM prescription
-- WHERE total_claim_count >= 3000;

-- b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
-- SELECT fd.drug_name, B.total_claim_count,
-- 	(CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid_YES'
-- 	 ELSE 'opioid_NO'
-- 	 END) AS drug_type
-- 	 FROM drug AS fd
-- LEFT JOIN prescription AS B
-- 	ON fd.drug_name = B.drug_name
-- WHERE B.total_claim_count >= 3000
-- ORDER BY B.total_claim_count DESC;

-- c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.
-- SELECT P.nppes_provider_first_name, p.nppes_provider_last_name, fd.drug_name, B.total_claim_count,
-- 	(CASE WHEN opioid_drug_flag = 'Y' THEN 'opioid_YES'
-- 	 ELSE 'opioid_NO'
-- 	 END) AS drug_type
-- 	 FROM drug AS fd
-- LEFT JOIN prescription AS B
-- 	ON fd.drug_name = B.drug_name
-- LEFT JOIN prescriber AS P
-- WHERE B.total_claim_count >= 3000
-- GROUP BY P.nppes_provider_first_name, p.nppes_provider_last_name
-- ORDER BY B.total_claim_count DESC;


-- 7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville and the number of claims they had for each opioid. Hint: The results from all 3 parts will have 637 rows.

-- a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Managment') in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). Warning: Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.
-- SELECT pr.npi  , drug.drug_name
-- FROM prescriber AS pr

-- CROSS JOIN drug 

-- WHERE specialty_description = 'Pain Management'
-- AND pr.nppes_provider_city = 'NASHVILLE'
-- AND opioid_drug_flag = 'Y';

-- b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
-- SELECT pr.npi, drug.drug_name, total_claim_count
-- FROM prescriber AS pr
-- CROSS JOIN drug 
-- FULL JOIN prescription USING(npi, drug_name)
-- WHERE specialty_description = 'Pain Management'
-- AND pr.nppes_provider_city = 'NASHVILLE'
-- AND opioid_drug_flag = 'Y';


-- c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.
-- SELECT pr.npi, drug.drug_name, COALESCE(total_claim_count,0)
-- FROM prescriber AS pr
-- CROSS JOIN drug 
-- FULL JOIN prescription USING(npi, drug_name)
-- WHERE specialty_description = 'Pain Management'
-- AND pr.nppes_provider_city = 'NASHVILLE'
-- AND opioid_drug_flag = 'Y';

--Part 2
-- 1. How many npi numbers appear in the prescriber table but not in the prescription table?
-- SELECT COUNT(DISTINCT npi)
-- FROM prescriber 
-- LEFT JOIN prescription AS rx
-- USING (npi)
-- WHERE rx.npi IS NULL;
-- ANSWER: 4,458

-- 2.
-- a. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Family Practice.
-- SELECT generic_name, SUM(total_claim_count) as sum_of_prescription
-- FROM prescription
-- LEFT JOIN prescriber
-- USING (npi)
-- LEFT JOIN drug
-- USING (drug_name)
-- WHERE specialty_description = 'Family Practice'
-- GROUP BY generic_name
-- ORDER BY sum_of_prescription DESC
-- LIMIT 5;

-- b. Find the top five drugs (generic_name) prescribed by prescribers with the specialty of Cardiology.
-- SELECT generic_name, SUM(total_claim_count) as sum_of_prescription
-- FROM prescription
-- LEFT JOIN prescriber
-- USING (npi)
-- LEFT JOIN drug
-- USING (drug_name)
-- WHERE specialty_description = 'Cardiology'
-- GROUP BY generic_name
-- ORDER BY sum_of_prescription DESC
-- LIMIT 5;

-- c. Which drugs appear in the top five prescribed for both Family Practice prescribers and Cardiologists? Combine what you did for parts a and b into a single query to answer this question.
SELECT fam.generic_name AS fam_practice_drug,
fam.sum_of_prescription AS Total,
cardi.generic_name AS cardio_drug,
cardi.sum_of_prescription AS Total

FROM (SELECT generic_name, SUM(total_claim_count) as sum_of_prescription
FROM prescription
LEFT JOIN prescriber
USING (npi)
INNER JOIN drug
USING (drug_name)
WHERE specialty_description = 'Cardiology'
GROUP BY generic_name
ORDER BY sum_of_prescription DESC
LIMIT 5) AS cardi

INNER JOIN (SELECT generic_name, SUM(total_claim_count) as sum_of_prescription
FROM prescription
LEFT JOIN prescriber
USING (npi)
INNER JOIN drug
USING (drug_name)
WHERE specialty_description = 'Family Practice'
GROUP BY generic_name
ORDER BY sum_of_prescription DESC
LIMIT 5) AS fam
USING (generic_name);

--3. Your goal in this question is to generate a list of the top prescribers in each of the major metropolitan areas of Tennessee. 

-- a. First, write a query that finds the top 5 prescribers in Nashville in terms of the total number of claims (total_claim_count) across all drugs. Report the npi, the total number of claims, and include a column showing the city. 


-- b. Now, report the same for Memphis. 


-- c. Combine your results from a and b, along with the results for Knoxville and Chattanooga.










