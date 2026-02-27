/*Checking for duplicate data in each table*/
SELECT*
FROM(SELECT*
        ,COUNT(*) OVER( PARTITION BY agent_city
                        ,experience_years
                        ,base_commission_rate
                        ,agent_rating) AS num_of_duplicate
FROM agents
) a
WHERE num_of_duplicate > 1;

SELECT*
FROM(SELECT*
        ,COUNT(*) OVER( PARTITION BY signup_date
                                    ,home_city
                                    ,segment
                                    ,age
                                    ,household_size
                                    ,income_band
                                    ,acquisition_channel
                                    ,propensity_score) AS num_of_duplicate
FROM customers
) c
WHERE num_of_duplicate > 1;


SELECT*
FROM(SELECT*
        ,COUNT(*) OVER( PARTITION BY city
                                    ,neighborhood_code
                                    ,property_type
                                    ,size_sqm
                                    ,bedrooms
                                    ,bathrooms
                                    ,year_built
                                    ,location_score
                                    ,amenities_count
                                    ,list_price
                                    ,has_parking
                                    ,near_transit
                                    ,near_school) AS num_of_duplicate
FROM properties
) p
WHERE num_of_duplicate > 1;

SELECT*
FROM(SELECT*
        ,COUNT(*) OVER( PARTITION BY property_id
                                    ,agent_id
                                    ,listing_date
                                    ,listing_channel
                                    ,listed_price
                                    ,sold_flag
                                    ,days_on_market
                                    ,close_date) AS num_of_duplicate
FROM listings
) l
WHERE num_of_duplicate > 1;

SELECT*
FROM(SELECT*
        ,COUNT(*) OVER( PARTITION BY customer_id
                                    ,month
                                    ,signup_month
                                    ,propensity_score
                                    ,segment
                                    ,acquisition_channel
                                    ,home_city
                                    ,calls
                                    ,inquiries
                                    ,offers
                                    ,saves
                                    ,views
                                    ,visits
                                    ,sessions
                                    ,avg_session_min
                                    ,revenue
                                    ,deals
                                    ,engagement_score
                                    ,engagement_3m
                                    ,churn_risk
                                    ,churned,churn_month) AS num_of_duplicate
FROM customers_monthly_metrics
) cmm
WHERE num_of_duplicate > 1;

SELECT*
FROM(SELECT*
        ,COUNT(*) OVER( PARTITION BY listing_id
                                    ,property_id
                                    ,agent_id
                                    ,customer_id
                                    ,city
                                    ,deal_date
                                    ,deal_price
                                    ,commission_amount
                                    ,payment_mode
                                    ,deal_status) AS num_of_duplicate
FROM transactions
) t
WHERE num_of_duplicate > 1;

/*Checking for missing data*/

/*Table Agents*/
SELECT*
FROM agents
WHERE agent_city IS NULL
        OR experience_years IS NULL
        OR base_commission_rate IS NULL
        OR agent_rating IS NULL;
--There are three null values in the agent rating column 
--possibly because the ratings have not yet been provided
--Analyzing the number of null values in the agent rating column based on years of experience
SELECT
        experience_years AS experience
        ,COUNT(experience_years) AS number_of_data
        ,COUNT(agent_rating) AS rating_not_null
        ,SUM(CASE
                WHEN agent_rating IS NULL
                THEN 1 ELSE 0 
                END) AS rating_is_null
FROM agents
GROUP BY experience
ORDER BY
        experience_years;
--Handling missing values in the agent rating column by imputing the average rating based on years of experience
WITH AVG_rating AS
        (SELECT
        experience_years
        ,ROUND(AVG(agent_rating):: numeric,2) AS AVG_rating
        FROM agents
        WHERE agent_rating IS NOT NULL  
        GROUP BY
                experience_years
        ORDER BY
                experience_years)
UPDATE agents a
SET agent_rating = ar.AVG_rating
FROM AVG_rating ar
WHERE a.experience_years = ar.experience_years AND
        agent_rating IS NULL;
SELECT
        experience_years
        ,agent_rating
FROM agents
ORDER BY
        experience_years;
SELECT*
FROM agents

/*Table customers*/
SELECT*
FROM customers
WHERE signup_date IS NULL
        OR home_city IS NULL
        OR segment IS NULL
        OR age IS NULL
        OR household_size IS NULL
        OR income_band IS NULL
        OR acquisition_channel IS NULL
        OR propensity_score IS NULL
--There are null values in the age column and income_band column
--Handling missing data in the age column using the median value
SELECT*
FROM customers
WHERE age IS NULL;

WITH median_age AS(
        SELECT percentile_cont(0.5)
        WITHIN GROUP (ORDER BY age) AS med_age
        FROM customers
        WHERE age IS NOT NULL
)
UPDATE customers c
SET age = ma.med_age
FROM median_age ma
WHERE c.age IS NULL;

--Handling missing values in the income_band column by replacing null values with ‘Unknown’
UPDATE customers
SET income_band = 'Unknown'
WHERE income_band IS NULL;

SELECT*
FROM customers;

/*Table properties*/

SELECT*
FROM properties
WHERE property_id IS NULL
        OR city IS NULL
        OR neighborhood_code IS NULL
        OR property_type IS NULL 
        OR size_sqm IS NULL 
        OR bedrooms IS NULL
        OR bathrooms IS NULL
        OR year_built IS NULL
        OR location_score IS NULL
        OR amenities_count IS NULL
        OR list_price IS NULL
        OR has_parking IS NULL
        OR near_transit IS NULL
        OR near_school IS NULL;
--Null values were found in the location_score and amenities_count columns
--As these values could not be reliably imputed based on other rows, they were retained as null.

SELECT*
FROM listings
WHERE listing_id IS NULL
        OR property_id IS NULL
        OR agent_id IS NULL
        OR listing_date IS NULL
        OR listing_channel IS NULL
        OR listed_price IS NULL
        OR sold_flag IS NULL
        OR days_on_market IS NULL
        OR close_date IS NULL
--The analysis identified null values in the close_date column. 
--These null values were retained as they could not be reliably imputed based on other rows.

SELECT*
FROM customers_monthly_metrics
WHERE customer_id IS NULL
        OR month IS NULL
        OR signup_month IS NULL
        OR propensity_score IS NULL
        OR segment IS NULL
        OR acquisition_channel IS NULL
        OR home_city IS NULL
        OR calls IS NULL
        OR inquiries IS NULL
        OR offers IS NULL
        OR saves IS NULL
        OR views IS NULL
        OR visits IS NULL
        OR sessions IS NULL
        OR avg_session_min IS NULL
        OR revenue IS NULL
        OR deals IS NULL
        OR engagement_score IS NULL
        OR engagement_3m IS NULL
        OR churn_risk IS NULL
        OR churned IS NULL
        OR churn_month IS NULL;
--The analysis identified null values in the churned and churn_month columns. 
--These null values were retained, as they could not be reliably imputed based on other rows.

SELECT*
FROM transactions
WHERE transaction_id IS NULL
        OR listing_id IS NULL
        OR property_id IS NULL 
        OR agent_id IS NULL
        OR customer_id IS NULL
        OR city IS NULL
        OR deal_date IS NULL
        OR deal_price IS NULL
        OR commission_amount IS NULL
        OR payment_mode IS NULL
        OR deal_status IS NULL;

SELECT t.property_id,
        t.deal_price,
        p.list_price
FROM transactions t
INNER JOIN properties p
ON t.property_id = p.property_id
ORDER BY
        property_id;

UPDATE transactions t
SET deal_price = p.list_price
FROM properties p
WHERE t.property_id = p.property_id AND t.deal_price IS NULL;

UPDATE transactions
SET payment_mode = 'Not Recorded'
WHERE payment_mode IS NULL

--Null data was found in the deal_price and payment_method columns.
--To handle the missing values, the list_price from the property table was used to fill in the missing values in the deal_price column. 
--Additionally, the value "Not Recorded" was assigned to the empty entries in the payment_method column.
