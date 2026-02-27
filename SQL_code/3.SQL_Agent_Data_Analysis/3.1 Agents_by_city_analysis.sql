/*
This analysis is conducted to identify the distribution patterns of agents in each city, based on their rating categories and years of experience.
The analysis will generate the following insights
1. Number of agents in each city
2. Classifying agents into Low, Mid, and High categories based on their rating scores
3. Number of agents in each city based on agent rating categories
4. Percentage of agent performance in each city based on rating categories 
5. Categorizing agents into Junior, Mid-level, and Senior groups based on their years of experience
6. Number of agents in each city based on experience categories
7. Percentage of agent performance in each city based on experience categories 
*/

SELECT
    agent_city
    ,COUNT(agent_id) AS number_of_agents
FROM agents
GROUP BY agent_city
ORDER BY number_of_agents DESC;

SELECT *
    ,CASE
        WHEN agent_rating >=1.00 AND agent_rating <=2.33 THEN 'Low'
        WHEN agent_rating >2.33 AND agent_rating <=3.66 THEN 'Mid'
        WHEN agent_rating >3.66 AND agent_rating <=5.00 THEN 'High'
    END AS rating_category
FROM agents;

WITH Agents_Rat_Category AS 
    (SELECT *
        ,CASE
            WHEN agent_rating >=1.00 AND agent_rating <=2.33 THEN 'Low'
            WHEN agent_rating >2.33 AND agent_rating <=3.66 THEN 'Mid'
            WHEN agent_rating >3.66 AND agent_rating <=5.00 THEN 'High'
        END AS rating_category
    FROM agents)
SELECT agent_city
        ,COUNT(CASE
                WHEN rating_category = 'High' 
                THEN 1 ELSE NULL 
                END) AS num_of_cat_high
        ,COUNT(CASE
                WHEN rating_category = 'Mid'
                THEN 1 ELSE NULL
                END) AS num_of_cat_mid
        ,COUNT(CASE
                WHEN rating_category = 'Low'
                THEN 1 ELSE NULL
                END) AS num_of_cat_low
FROM Agents_Rat_Category
GROUP BY agent_city
ORDER BY num_of_cat_high DESC;

WITH Agents_Rat_Category AS 
    (SELECT *
        ,CASE
            WHEN agent_rating >=1.00 AND agent_rating <=2.33 THEN 'Low'
            WHEN agent_rating >2.33 AND agent_rating <=3.66 THEN 'Mid'
            WHEN agent_rating >3.66 AND agent_rating <=5.00 THEN 'High'
        END AS rating_category
    FROM agents)
SELECT
        agent_city
        ,ROUND(SUM(CASE
                WHEN rating_category = 'High' 
                THEN 1 ELSE NULL 
                END)*100.0/COUNT(agent_id),1) AS percent_of_cat_high
        ,ROUND(SUM(CASE
                WHEN rating_category = 'Mid'
                THEN 1 ELSE NULL
                END)*100.0/COUNT(agent_id),1) AS percent_of_cat_mid
        ,ROUND(SUM(CASE
                WHEN rating_category = 'Low'
                THEN 1 ELSE NULL
                END)*100.0/COUNT(agent_id),1) AS percent_of_cat_low
FROM Agents_Rat_Category
GROUP BY agent_city;

SELECT*
   ,CASE
        WHEN experience_years >=0.00 AND experience_years <=4.6 THEN 'Junior'
        WHEN experience_years >4.6 AND experience_years <=9.2 THEN 'Mid-Level'
        WHEN experience_years >9.2 THEN 'Senior'
    END AS experience_category
FROM agents;




SELECT
    agent_city
    ,SUM(deal_price) AS total_sales
    ,COUNT(t.agent_id) AS number_of_transaction
FROM agents a
LEFT JOIN transactions t
ON a.agent_id = t.agent_id
GROUP BY agent_city
ORDER BY total_sales DESC;

WITH Agents_Rat_Category AS 
    (SELECT 
        agent_id
        ,agent_rating
        ,experience_years
        ,CASE
            WHEN agent_rating >=1.00 AND agent_rating <=2.33 THEN 'Low'
            WHEN agent_rating >2.33 AND agent_rating <=3.66 THEN 'Mid'
            WHEN agent_rating >3.66 AND agent_rating <=5.00 THEN 'High'
        END AS rating_category
    FROM agents),
   Agents_Total_Sales AS (SELECT 
        agent_id
        ,COUNT(agent_id) AS number_of_transaction
        ,SUM(deal_price) AS total_sales
    FROM transactions
    GROUP BY agent_id)
SELECT arc.*
    ,ats.number_of_transaction
    ,ats.total_sales
FROM Agents_Rat_Category arc
JOIN Agents_Total_Sales ats
ON arc.agent_id = ats.agent_id
ORDER BY
    total_sales DESC
LIMIT 10;
        



