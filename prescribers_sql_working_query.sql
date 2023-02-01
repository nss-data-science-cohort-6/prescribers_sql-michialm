
--1.

-- a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
SELECT npi, nppes_provider_last_org_name AS Last_Name, nppes_provider_first_name AS First_Name
FROM prescription
WHERE total_claim_count = (SELECT MAX(total_claim_count)
						   FROM prescription)
NATURAL JOIN prescriber
USING (npi);
						   
-- b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name, specialty_description, and the total number of claims.