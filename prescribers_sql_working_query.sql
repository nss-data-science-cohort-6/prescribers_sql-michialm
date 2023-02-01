
--1.

-- a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
-- SELECT npi, total_claim_count
-- FROM prescription
-- WHERE total_claim_count = (SELECT MAX(total_claim_count)
-- 						   FROM prescription);
--ANSWER: npi:1912011792; total_claim_count:4538
						   
-- b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, and the total number of claims.
SELECT npi, p2.nppes_provider_first_name, p2.nppes_provider_last_org_name, p2.specialty_description, total_claim_count
FROM prescription AS p1
INNER JOIN prescriber AS p2
USING (npi)
WHERE total_claim_count = (SELECT MAX(total_claim_count)
						   FROM prescription);