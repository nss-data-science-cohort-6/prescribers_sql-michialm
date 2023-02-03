
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
-- FROM prescriber AS A
-- LEFT JOIN prescription AS B
-- ON A.npi = B.npi
-- WHERE B.npi IS NULL;
--ANSWER: ?

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
SELECT drug_name,
	CASE 
		WHEN opioid_drug_flag = 'Y' THEN 'opioid'
		WHEN antibiotic_drug_flag = 'Y' THEN 'antibiotic'
		ELSE 'neither'
	END AS drug_type
FROM drug;
--b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics. Hint: Format the total costs as MONEY for easier comparision.