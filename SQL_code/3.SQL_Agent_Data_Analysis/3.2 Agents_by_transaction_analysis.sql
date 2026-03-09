
SELECT
    agent_city
    ,SUM(t.deal_price) AS total_sales
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
