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
    *
FROM agents
LIMIT 0

--1. Number of agents in each city
SELECT
    agent_city
    ,COUNT(agent_id) AS number_of_agents
FROM agents
GROUP BY agent_city
ORDER BY number_of_agents DESC;

--2. Classifying agents into Low, Mid, and High categories based on their rating scores
SELECT *
    ,CASE
        WHEN agent_rating >=1.00 AND agent_rating <=2.33 THEN 'Low'
        WHEN agent_rating >2.33 AND agent_rating <=3.66 THEN 'Mid'
        WHEN agent_rating >3.66 AND agent_rating <=5.00 THEN 'High'
    END AS rating_category
FROM agents;

--3. Number of agents in each city based on agent rating categories
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

--4. Percentage of agent performance in each city based on rating categories 
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
GROUP BY agent_city
ORDER BY percent_of_cat_high DESC;

--5. Categorizing agents into Junior, Mid-level, and Senior groups based on their years of experience
SELECT*
   ,CASE
        WHEN experience_years >=0.00 AND experience_years <=4.6 THEN 'Junior'
        WHEN experience_years >4.6 AND experience_years <=9.2 THEN 'Mid-Level'
        WHEN experience_years >9.2 THEN 'Senior'
    END AS experience_category
FROM agents;

--6. Number of agents in each city based on experience categories
WITH Agents_Experience_Category AS 
    (SELECT*
   ,CASE
        WHEN experience_years >=0.00 AND experience_years <=4.6 THEN 'Junior'
        WHEN experience_years >4.6 AND experience_years <=9.2 THEN 'Mid-Level'
        WHEN experience_years >9.2 THEN 'Senior'
    END AS experience_category
    FROM agents)
SELECT agent_city
        ,COUNT(CASE
                WHEN experience_category = 'Senior' 
                THEN 1 ELSE NULL 
                END) AS num_of_cat_snr
        ,COUNT(CASE
                WHEN experience_category = 'Mid-Level'
                THEN 1 ELSE NULL
                END) AS num_of_cat_midlev
        ,COUNT(CASE
                WHEN experience_category = 'Junior'
                THEN 1 ELSE NULL
                END) AS num_of_cat_jnr
FROM Agents_Experience_Category
GROUP BY agent_city
ORDER BY num_of_cat_snr DESC;

--7. Percentage of agent performance in each city based on experience categories
WITH Agents_Experience_Category AS 
    (SELECT*
        ,CASE
            WHEN experience_years >=0.00 AND experience_years <=4.6 THEN 'Junior'
            WHEN experience_years >4.6 AND experience_years <=9.2 THEN 'Mid-Level'
            WHEN experience_years >9.2 THEN 'Senior'
        END AS experience_category
    FROM agents)
SELECT
        agent_city
        ,ROUND(SUM(CASE
                WHEN experience_category = 'Junior' 
                THEN 1 ELSE NULL 
                END)*100.0/COUNT(agent_id),1) AS percent_of_cat_jnr
        ,ROUND(SUM(CASE
                WHEN experience_category = 'Mid-Level'
                THEN 1 ELSE NULL
                END)*100.0/COUNT(agent_id),1) AS percent_of_cat_midlev
        ,ROUND(SUM(CASE
                WHEN experience_category = 'Senior'
                THEN 1 ELSE NULL
                END)*100.0/COUNT(agent_id),1) AS percent_of_cat_snr
FROM Agents_Experience_Category
GROUP BY agent_city
ORDER BY percent_of_cat_snr DESC;

--Analysis of the rating percentages of agents according to their years of experience.
WITH Percent_by_Experience_Cat AS 
    (SELECT *
        ,CASE
            WHEN agent_rating >=1.00 AND agent_rating <=2.33 THEN 'Low'
            WHEN agent_rating >2.33 AND agent_rating <=3.66 THEN 'Mid'
            WHEN agent_rating >3.66 AND agent_rating <=5.00 THEN 'High'
        END AS rating_category,
        CASE
            WHEN experience_years >=0.00 AND experience_years <=4.6 THEN 'Junior'
            WHEN experience_years >4.6 AND experience_years <=9.2 THEN 'Mid-Level'
            WHEN experience_years >9.2 THEN 'Senior'
        END AS experience_category
    FROM agents)
SELECT agent_city
        ,COUNT(CASE
                    WHEN experience_category = 'Senior' 
                    THEN 1 ELSE NULL 
                END) AS num_of_cat_jnr
        ,ROUND(COUNT(CASE
                        WHEN rating_category = 'High' AND experience_category = 'Senior'
                        THEN 1 ELSE NULL 
                    END)*100/COUNT(CASE 
                                        WHEN experience_category = 'Senior' 
                                        THEN 1 
                                    END),1) AS num_high_snr
        ,ROUND(COUNT(CASE
                        WHEN rating_category = 'Mid' AND experience_category = 'Senior'
                        THEN 1 ELSE NULL 
                    END)*100/COUNT(CASE 
                                        WHEN experience_category = 'Senior'
                                        THEN 1 
                                    END),1) AS num_mid_snr
        ,ROUND(COUNT(CASE
                        WHEN rating_category = 'Low' AND experience_category = 'Senior'
                        THEN 1 ELSE NULL 
                    END)*100/COUNT(CASE 
                                        WHEN experience_category = 'Senior'
                                        THEN 1 
                                    END),1) AS num_low_snr
        ,COUNT(CASE
                    WHEN experience_category = 'Mid-Level'
                    THEN 1 ELSE NULL
                END) AS num_of_cat_midlev
        ,ROUND(COUNT(CASE
                        WHEN rating_category = 'High' AND experience_category = 'Mid-Level'
                        THEN 1 ELSE NULL 
                    END)*100/COUNT(CASE 
                                        WHEN experience_category = 'Mid-Level' 
                                        THEN 1 
                                    END),1) AS num_high_mid
        ,ROUND(COUNT(CASE
                        WHEN rating_category = 'Mid' AND experience_category = 'Mid-Level'
                        THEN 1 ELSE NULL 
                    END)*100/COUNT(CASE 
                                        WHEN experience_category = 'Mid-Level'
                                        THEN 1 
                                    END),1) AS num_mid_mid
        ,ROUND(COUNT(CASE
                        WHEN rating_category = 'Low' AND experience_category = 'Mid-Level'
                        THEN 1 ELSE NULL 
                    END)*100/COUNT(CASE 
                                        WHEN experience_category = 'Mid-Level'
                                        THEN 1 
                                    END),1) AS num_low_mid
        ,COUNT(CASE
                    WHEN experience_category = 'Junior'
                    THEN 1 ELSE NULL
                END) AS num_of_cat_snr
        ,ROUND(COUNT(CASE
                    WHEN rating_category = 'High' AND experience_category = 'Junior'
                    THEN 1 ELSE NULL 
                END)*100/COUNT(CASE 
                                    WHEN experience_category = 'Junior' 
                                    THEN 1 
                                END),1) AS num_high_jnr
        ,ROUND(COUNT(CASE
                        WHEN rating_category = 'Mid' AND experience_category = 'Junior'
                        THEN 1 ELSE NULL 
                END)*100/COUNT(CASE 
                                    WHEN experience_category = 'Junior'
                                    THEN 1 
                                END),1) AS num_mid_jnr
        ,ROUND(COUNT(CASE
                        WHEN rating_category = 'Low' AND experience_category = 'Junior'
                        THEN 1 ELSE NULL 
                    END)*100/COUNT(CASE 
                                        WHEN experience_category = 'Junior'
                                        THEN 1 
                                    END),1) AS num_low_jnr
FROM Percent_by_Experience_Cat
GROUP BY agent_city
ORDER BY agent_city; 

        



