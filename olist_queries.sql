-- make a model with linear regression that tries to predict the estimated cumulative 6 month revenue from a new customer

-- r-squared tells given a set of independent variables, how good does that fit the data on those factors and the dependent variable

-- the individual coefficients get multiplied by the individual variables to get closer to the dependent variable. you have to check the p value to see if any of the coefficients are significant values




CREATE TABLE customer(
	customer_id varchar(255) NOT NULL
	,customer_unique_id varchar(255) NOT NULL
	,customer_zip_code_prefix integer NOT NULL
	,customer_city varchar(255) NOT NULL
	,customer_state varchar(255) NOT NULL
	,PRIMARY KEY(customer_id)

COPY
	customer

FROM 
	'/Users/galvanize/Documents/regression/olist/olist_customers_dataset.csv'DELIMITER ',' CSV HEADER;





CREATE TABLE ordertest(
	order_id varchar(255) NOT NULL
	,customer_id varchar(255) NOT NULL
	,order_status varchar(255)
	,order_purchase_timestamp timestamp
	,order_approved_at timestamp
	,order_delivered_carrier_date timestamp
	,order_delivered_customer_date timestamp
	,order_estimated_delivery_date timestamp
	,PRIMARY KEY(order_id)
	,FOREIGN KEY (customer_id) REFERENCES customer(customer_id))


COPY
	ordertest

FROM 
	'/Users/galvanize/Documents/regression/olist/olist_orders_dataset.csv' DELIMITER ',' CSV HEADER;



CREATE TABLE order_item(
    order_id varchar(255) NOT NULL
    ,order_item_id varchar(255) NOT NULL
    ,product_id varchar(255) NOT NULL
    ,seller_id varchar(255) NOT NULL
    ,shipping_limit_date date NOT NULL
    ,price decimal
    ,freight_value decimal
    ,FOREIGN KEY (order_id) REFERENCES ordertest(order_id)
)

COPY order_item
FROM '/Users/galvanize/Documents/regression/olist/olist_order_items_dataset.csv' DELIMITER ',' CSV HEADER;





WITH latest_purchase AS(

SELECT
	customer_id
	,MAX(order_purchase_timestamp) as last_purchase

FROM
	ordertest

GROUP BY 
	customer_id

ORDER BY
	2)


SELECT 
	COUNT(active) as type_customer
	,active

FROM
	(SELECT
	*
	,CASE WHEN last_purchase <= '2018-01-01'
	THEN 'inactive'
	ELSE 'active'
	END as active

FROM 
	latest_purchase) AS test

GROUP BY
	active


------

SELECT
	count(amount)
	,amount

FROM 
	payment

GROUP BY 
	amount

----

SELECT 
	customer_id 
	,COUNT(order_id)

FROM 
	ordertest

GROUP BY
	1

ORDER BY
	2 DESC
