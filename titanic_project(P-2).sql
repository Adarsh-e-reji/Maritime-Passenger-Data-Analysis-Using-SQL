#-------------------------------------------------------------------------
#[DATA ANALYSIS ON TITANIC PASSENGER DATA]
#-------------------------------------------------------------------------
use adarsh; #activating my DB
#-------------------------------------------------------------------------
select * from passengers;
select * from tickets;
select * from survivals;
select * from families;
select * from embarkation;
#-------------------------------------------------------------------------
#1. What percentage of passengers survived overall?
SELECT ROUND(AVG(survived)*100,2) AS survival_rate_percent 
FROM survivals;

#2. What was the survival rate by passenger class?
SELECT t.class, ROUND(AVG(s.survived) * 100, 2) AS survival_rate_percent
FROM tickets t
JOIN survivals s ON t.passenger_id = s.passenger_id
GROUP BY t.class;

#3. How did survival rate differ between genders in each class?
SELECT t.class, p.gender, ROUND(AVG(s.survived) * 100, 2) AS survival_rate_percent
FROM tickets t
JOIN survivals s ON t.passenger_id = s.passenger_id
JOIN passengers p ON t.passenger_id = p.passenger_id
GROUP BY t.class, p.gender;

#4. What is the average family size for survivors vs. non-survivors?
SELECT s.survived, ROUND(AVG(f.siblings_spouses_aboard + f.parents_children_aboard), 2) AS avg_family_size
FROM survivals s
JOIN families f 
ON s.passenger_id = f.passenger_id
GROUP BY s.survived;

#5. Which embarkation point had the most passengers?
SELECT e.embarked, COUNT(*) AS total_passengers
FROM embarkation e
GROUP BY e.embarked
ORDER BY total_passengers DESC;

#6. What was the survival rate by embarkation port?
SELECT e.embarked, ROUND(AVG(s.survived) * 100, 2) AS survival_rate_percent
FROM embarkation e
JOIN survivals s ON e.passenger_id = s.passenger_id
GROUP BY e.embarked;

#7. Identify passengers who did not survive and analyze their family size
SELECT p.name, f.siblings_spouses_aboard + f.parents_children_aboard AS family_size
FROM passengers p
LEFT JOIN survivals s ON p.passenger_id = s.passenger_id
LEFT JOIN families f ON p.passenger_id = f.passenger_id
WHERE s.survived = 0;

#8. Did people who paid more survive more often?
SELECT CASE 
         WHEN t.fare >= 70 THEN 'High'
         WHEN t.fare BETWEEN 30 AND 70 THEN 'Medium'
         ELSE 'Low'
       END AS fare_category,
       ROUND(AVG(s.survived) * 100, 2) AS survival_rate_percent
FROM tickets t
JOIN survivals s ON t.passenger_id = s.passenger_id
GROUP BY fare_category;

#9. Who were the top 5 oldest survivors?
SELECT p.name, p.age, t.class, p.gender
FROM passengers p
JOIN survivals s ON p.passenger_id = s.passenger_id
JOIN tickets t ON t.passenger_id = p.passenger_id
WHERE s.survived = 1
ORDER BY p.age DESC
LIMIT 5;

#10. Determine gender-wise survival rate in each class
SELECT t.class, p.gender, ROUND(AVG(s.survived) * 100, 2) AS survival_rate
FROM passengers p
JOIN survivals s ON p.passenger_id = s.passenger_id
JOIN tickets t ON p.passenger_id = t.passenger_id
GROUP BY t.class, p.gender;
