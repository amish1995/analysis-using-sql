CREATE DATABASE  ecommerce_db;
USE ecommerce_db;
CREATE TABLE ecommerce_shipping 
(
ID INT PRIMARY KEY, 
Warehouse_block	VARCHAR(1),
Mode_of_Shipment VARCHAR(10),	
Customer_care_calls	INT,
Customer_rating	INT,
Cost_of_the_Product	DECIMAL(10,2),
Prior_purchases	INT,
Product_importance	VARCHAR(10),
Gender	VARCHAR(10),
Discount_offered DECIMAL(10,2),
Weight_in_gms INT,
Reached_on_Time INT,
CHECK (Warehouse_block IN ('A','B','C','D','F')),
CHECK (Mode_of_Shipment IN ('Ship','Flight','Road')),
CHECK (Customer_rating BETWEEN 1 AND 5),
CHECK (Product_importance IN ('low', 'medium', 'high')),
CHECK (Gender IN ('M','F')),
CHECK (Reached_on_Time IN (0, 1))
);

-- Dataset 
select * from ecommerce_shipping;

-- 1. Total number of orders
select count(*) as total_orders from ecommerce_shipping;

-- 2. Orders delivered on time vs. delayed
select Reached_on_Time, count(*) as count from ecommerce_shipping group by Reached_on_Time;

-- 3. Average customer rating per shipment mode
select Mode_of_Shipment,avg(Customer_rating) as avg_cus_rating from ecommerce_shipping group by Mode_of_Shipment;

-- 4. Orders arranged based on their cost with high product importance and delayed delivery
select * from ecommerce_shipping where Product_importance='high' and Reached_on_Time=1 order by Cost_of_the_Product desc;

-- 5. Average cost of products per warehouse
select Warehouse_block,avg(Cost_of_the_Product) as avg_cost from ecommerce_shipping group by Warehouse_block;

-- 6. Total discounts given by shipment mode
select Mode_of_Shipment, sum(Discount_offered) as total_discounts from ecommerce_shipping group by Mode_of_Shipment;

-- 7. Average weight of delayed shipments
select avg(Weight_in_gms) as avg_weight from ecommerce_shipping where Reached_on_Time=1;

CREATE TABLE shipment_speed (
    Mode_of_Shipment VARCHAR(10),
    estimated_days INT
);

INSERT INTO shipment_speed VALUES
('Ship', 5),
('Flight', 2),
('Road', 7);

-- 8. INNER JOIN with shipment_speed
select e.ID, e.Mode_of_Shipment,s.estimated_days from ecommerce_shipping e INNER JOIN shipment_speed s on e.Mode_of_Shipment=s.Mode_of_Shipment;

-- 9. LEFT JOIN 
select e.ID, e.Mode_of_Shipment,s.estimated_days from ecommerce_shipping e LEFT JOIN shipment_speed s on e.Mode_of_Shipment=s.Mode_of_Shipment;

-- 10. RIGHT JOIN 
select e.ID, e.Mode_of_Shipment,s.estimated_days from ecommerce_shipping e RIGHT JOIN shipment_speed s on e.Mode_of_Shipment=s.Mode_of_Shipment;

-- 11. Customers who received a product costlier than the average
select * from ecommerce_shipping where Cost_of_the_Product >(select avg(Cost_of_the_Product) from ecommerce_shipping);


-- 12. View to track average rating by gender and shipment mode
create view avg_rating_view as select Gender,Mode_of_Shipment,avg(Customer_rating) as avg_rating from ecommerce_shipping group by Gender,Mode_of_Shipment;
select * from avg_rating_view;

-- 13. View of delayed high-importance orders
create view delayed_imp_view as select * from ecommerce_shipping where Product_importance='high' and  Reached_on_Time=1;
select * from delayed_imp_view;

-- 14. Index on delivery status for faster filtering
create index idx_delivery on ecommerce_shipping(Reached_on_Time);
explain select count(*) from ecommerce_shipping where Reached_on_Time = 1;

-- 15. Index on mode_of_shipment for group-by queries
create index idx_mode_shipment on ecommerce_shipping(Mode_of_Shipment);
explain select Mode_of_Shipment,count(*) from ecommerce_shipping group by Mode_of_Shipment;
