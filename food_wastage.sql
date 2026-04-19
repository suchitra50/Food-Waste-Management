CREATE TABLE providers (
    provider_id INT PRIMARY KEY,
    name TEXT,
    type TEXT,
    address TEXT,
    city TEXT,
    contact TEXT
);
SELECT COUNT(*) FROM providers;
CREATE TABLE receivers (
    receiver_id INT PRIMARY KEY,
    name TEXT,
    type TEXT,
    city TEXT,
    contact TEXT
);
SELECT COUNT(*) FROM receivers;
CREATE TABLE IF NOT EXISTS food_listings (
    table_id INT PRIMARY KEY,
    food_name TEXT,
    quantity INT,
    expiry_date DATE,
    provider_id INT,
    location TEXT,
    food_type TEXT,
    meal_type TEXT
);
select count(*) from food_listings;
DROP TABLE IF EXISTS food_listings;

CREATE TABLE food_listings (
    food_id INT PRIMARY KEY,
    food_name TEXT,
    quantity INT,
    expiry_date DATE,
    provider_id INT,
	provider_type VARCHAR(50),
    location TEXT,
    food_type TEXT,
    meal_type TEXT
);
ALTER TABLE food_listings
ADD CONSTRAINT fk_provider
FOREIGN KEY (provider_id)
REFERENCES providers(provider_id);

SELECT DISTINCT provider_id FROM food_listings;
SELECT provider_id FROM providers;

CREATE TABLE claims (
    claim_id SERIAL PRIMARY KEY,
    food_id INT NOT NULL,
    receiver_id INT NOT NULL,
    status VARCHAR(50) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
select count(*) from claims;
select count(*) from food_listings;

 1. How many food providers and receivers are there in each city?
SELECT 
    COALESCE(p.city, r.city) AS city,
    COUNT(DISTINCT p.provider_id) AS total_providers,
    COUNT(DISTINCT r.receiver_id) AS total_receivers
FROM providers p
FULL OUTER JOIN receivers r
ON p.city = r.city
GROUP BY COALESCE(p.city, r.city)
ORDER BY city;

 2. Which type of food provider contributes the most food?
 SELECT 
    Provider_Type,
    SUM(Quantity) AS Total_Quantity
FROM food_listings
GROUP BY Provider_Type
ORDER BY Total_Quantity DESC;

3. What is the contact information of food providers in a specific city?
SELECT 
    Name,
    Contact,
    Address
FROM providers
WHERE City = 'Adambury';

SELECT 
    Name,
    Contact,
    Address,
    City
FROM providers;

 4. Which receivers have claimed the most food?
 SELECT 
    r.Name,
    COUNT(c.Claim_ID) AS Total_Claims
FROM receivers r
JOIN claims c ON r.Receiver_ID = c.Receiver_ID
GROUP BY r.Name
ORDER BY Total_Claims DESC
LIMIT 10;

 5. What is the total quantity of food available from all providers?
 SELECT 
    SUM(Quantity) AS Total_Food_Quantity
FROM food_listings;

 6. Which city has the highest number of food listings?
 SELECT 
    Location,
    COUNT(Food_ID) AS Total_Listings
FROM food_listings
GROUP BY Location
ORDER BY Total_Listings desc
LIMIT 1;

7. What are the most commonly available food types?
SELECT 
    Food_Type,
    COUNT(Food_ID) AS Listings_Count
FROM food_listings
GROUP BY Food_Type
ORDER BY Listings_Count DESC;

 8. How many food claims have been made for each food item?
 SELECT 
    fl.Food_Name,
    COUNT(c.Claim_ID) AS Total_Claims
FROM food_listings fl
LEFT JOIN claims c ON fl.Food_ID = c.Food_ID
GROUP BY fl.Food_Name
ORDER BY Total_Claims DESC;

 9. Which provider has had the highest number of successful food claims?
 SELECT 
    p.Name,
    COUNT(c.Claim_ID) AS Successful_Claims
FROM providers p
JOIN food_listings fl ON p.Provider_ID = fl.Provider_ID
JOIN claims c ON fl.Food_ID = c.Food_ID
WHERE c.Status = 'Completed'
GROUP BY p.Name
ORDER BY Successful_Claims DESC
LIMIT 1;

 10. What percentage of food claims are completed vs pending vs cancelled?
 SELECT 
    Status,
    COUNT(*) AS Count_Status,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM claims), 2) AS Percentage
FROM claims
GROUP BY Status;

11. What is the average quantity of food claimed per receiver?
SELECT 
    r.Name,
    ROUND(AVG(fl.Quantity), 2) AS Avg_Quantity_Claimed
FROM receivers r
JOIN claims c ON r.Receiver_ID = c.Receiver_ID
JOIN food_listings fl ON c.Food_ID = fl.Food_ID
GROUP BY r.Name
ORDER BY Avg_Quantity_Claimed DESC;

12. Which meal type is claimed the most?
SELECT 
    fl.Meal_Type,
    COUNT(c.Claim_ID) AS Total_Claims
FROM food_listings fl
JOIN claims c ON fl.Food_ID = c.Food_ID
GROUP BY fl.Meal_Type
ORDER BY Total_Claims DESC;

13. What is the total quantity of food donated by each provider?
SELECT 
    p.Name,
    SUM(fl.Quantity) AS Total_Donated
FROM providers p
JOIN food_listings fl ON p.Provider_ID = fl.Provider_ID
GROUP BY p.Name
ORDER BY Total_Donated DESC;

14. Most demanded food type per city.
SELECT 
    fl.Location,
    fl.Food_Type,
    COUNT(c.Claim_ID) AS Claims_Count
FROM food_listings fl
JOIN claims c ON fl.Food_ID = c.Food_ID
GROUP BY fl.Location, fl.Food_Type
ORDER BY fl.Location, Claims_Count DESC;

15. Month with highest number of claims.
SELECT 
    TO_CHAR(TO_TIMESTAMP(clean_timestamp, 'DD/MM/YYYY HH24:MI'), 'YYYY-MM') AS claim_month,
    COUNT(*) AS total_claims
FROM claims
GROUP BY claim_month
ORDER BY total_claims DESC
LIMIT 1;

