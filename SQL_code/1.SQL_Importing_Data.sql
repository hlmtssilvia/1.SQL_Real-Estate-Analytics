CREATE TABLE agents (
  agent_id TEXT PRIMARY KEY
  ,agent_city VARCHAR(100)
  ,experience_years DOUBLE PRECISION
  ,base_commission_rate DOUBLE PRECISION
  ,agent_rating DOUBLE PRECISION
);
COPY agents
FROM'E:\PORTOFOLIO\SQL\1.SQL_Real Estate Analytics\Real_Estate_Data.csv\agents.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING'UTF-8');

CREATE TABLE customers (
  customer_id TEXT PRIMARY KEY
  ,signup_date DATE
  ,home_city VARCHAR(100)
  ,segment VARCHAR(100)
  ,age DOUBLE PRECISION
  ,household_size INT
  ,income_band VARCHAR(100)
  ,acquisition_channel VARCHAR(100)
  ,propensity_score DOUBLE PRECISION
);
COPY customers
FROM'E:\PORTOFOLIO\SQL\1.SQL_Real Estate Analytics\Real_Estate_Data.csv\customers.csv'
WITH (FORMAT csv, HEADER true, DELIMITER',',ENCODING'UTF-8');


CREATE TABLE properties (
  property_id TEXT PRIMARY KEY
  ,city VARCHAR (100)
  ,neighborhood_code VARCHAR (100)
  ,property_type VARCHAR (100)
  ,size_sqm DOUBLE PRECISION
  ,bedrooms INT
  ,bathrooms INT
  ,year_built INT 
  ,location_score DOUBLE PRECISION
  ,amenities_count DOUBLE PRECISION
  ,list_price INT
  ,has_parking VARCHAR(50)
  ,near_transit VARCHAR (50)
  ,near_school VARCHAR (50)
);
COPY properties
FROM'E:\PORTOFOLIO\SQL\1.SQL_Real Estate Analytics\Real_Estate_Data.csv\properties.csv'
WITH (FORMAT csv, HEADER true, DELIMITER',',ENCODING'UTF-8');


CREATE TABLE listings (
  listing_id TEXT PRIMARY KEY
  ,property_id TEXT 
  ,agent_id TEXT
  ,listing_date DATE
  ,listing_channel VARCHAR (100)
  ,listed_price INT
  ,sold_flag VARCHAR (50)
  ,days_on_market INT
  ,close_date DATE
);
COPY listings
FROM 'E:\PORTOFOLIO\SQL\1.SQL_Real Estate Analytics\Real_Estate_Data.csv\listings.csv'
WITH (FORMAT csv, HEADER true, DELIMITER',',ENCODING'UTF-8');


CREATE TABLE customers_monthly_metrics (
  customer_id TEXT 
  ,month DATE
  ,signup_month DATE
  ,propensity_score DOUBLE PRECISION
  ,segment VARCHAR(50)
  ,acquisition_channel VARCHAR(50)
  ,home_city VARCHAR(150)
  ,calls DECIMAL(10,1)
  ,inquiries DECIMAL(10,1)
  ,offers DECIMAL(10,1)
  ,saves DECIMAL(10,1)
  ,views DECIMAL(10,1)
  ,visits DECIMAL(10,1)
  ,sessions DOUBLE PRECISION
  ,avg_session_min DOUBLE PRECISION
  ,revenue DOUBLE PRECISION
  ,deals DECIMAL(10,1)
  ,engagement_score DOUBLE PRECISION
  ,engagement_3m DOUBLE PRECISION
  ,churn_risk DOUBLE PRECISION
  ,churned VARCHAR(50)
  ,churn_month DATE
  ,FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

COPY customers_monthly_metrics
FROM'E:\PORTOFOLIO\SQL\1.SQL_Real Estate Analytics\Real_Estate_Data.csv\customer_monthly_metrics.csv'
WITH (FORMAT csv, HEADER true, DELIMITER',', ENCODING'UTF-8')


CREATE TABLE transactions(
    transaction_id TEXT PRIMARY KEY
    ,listing_id TEXT
    ,property_id TEXT
    ,agent_id TEXT 
    ,customer_id TEXT 
    ,city VARCHAR (100)
    ,deal_date DATE 
    ,deal_price DECIMAL (15,1)
    ,commission_amount DOUBLE PRECISION
    ,payment_mode VARCHAR (100)
    ,deal_status VARCHAR (100)
    ,FOREIGN KEY (listing_id) REFERENCES listings(listing_id)
    ,FOREIGN KEY (property_id) REFERENCES properties(property_id)
    ,FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
    ,FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
COPY transactions
FROM'E:\PORTOFOLIO\SQL\1.SQL_Real Estate Analytics\Real_Estate_Data.csv\transactions.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF-8');

DROP TABLE transactions
