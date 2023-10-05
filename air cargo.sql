-- create database
CREATE database aircargo;
-- use aircargo
USE aircargo;

-- create route_details table using suitable data types for the fields, such as route_id, flight_num, origin_airport, destination_airport, aircraft_id, and distance_miles. 
-- Implement the check constraint for the flight number and unique constraint for the route_id fields. 
-- Also, make sure that the distance miles field is greater than 0
CREATE table route_details(route_id int unique, flight_num int check(flight_num >0), origin_airport text, destination_airport text, aircraft_id text, 
distance_miles int check(distance_miles >0));

-- display all the passengers (customers) who have travelled in routes 01 to 25. 
SELECT * from passengers_on_flights where route_id between 0 and 25 order by route_id desc;

-- identify the number of passengers and total revenue in business class from the ticket_details table.
SELECT count(customer_id) as number_of_passengers, sum(Price_per_ticket) as total_revenue_in_business from ticket_details where class_id = 'Bussiness';

-- display the full name of the customer by extracting the first name and last name from the customer table.
SELECT concat(first_name, ' ', last_name) as Full_Name from customer;

-- extract the customers who have registered and booked a ticket. Use data from the customer and ticket_details tables.
SELECT c. customer_id, t. no_of_tickets, t. class_id 
from customer c join ticket_details t
on c. customer_id = t. customer_id
where no_of_tickets > 0;

-- Write a query to identify the customer’s first name and last name based on their customer ID and brand (Emirates) from the ticket_details table.
SELECT c. first_name, last_name, t. customer_id, t. brand from customer c join ticket_details t on c. customer_id = t. customer_id 
where brand = 'Emirates';

-- identify the customers who have travelled by Economy Plus class using Group By and Having clause on the passengers_on_flights table.
SELECT COUNT(customer_id) AS Total_Customers FROM passengers_on_flights GROUP BY class_id HAVING class_id="Economy Plus";

-- identify whether the revenue has crossed 10000 using the IF clause on the ticket_details table.
SELECT sum(Price_per_ticket) as Total_Revenue, 
if (sum(Price_per_ticket) >10000, "YES", "NO") as Reveune_Crossed from ticket_details;

-- create and grant access to a new user to perform operations on a database 
CREATE USER 'Rajesh'@'localhost' IDENTIFIED BY 'test@123';

GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, REFERENCES, RELOAD on *.* TO 'Rajesh'@'localhost' WITH GRANT OPTION;	

REVOKE CREATE on *.* FROM 'Rajesh'@'localhost';

DESCRIBE mysql.user;

SELECT * FROM mysql.user;

DROP USER 'Rajesh'@'localhost';

DROP USER 'Suresh'@'localhost';

SELECT * FROM mysql.user;


-- find the maximum ticket price for each class using window functions on the ticket_details table.
SELECT class_id as Class, max(Price_per_ticket) as Max_Ticket_Price from aircargo.ticket_details
 group by class_id order by class_id;
 
 -- extract the passengers whose route ID is 4 by improving the speed and performance of the passengers_on_flights table.
SELECT customer_id, route_id from passengers_on_flights where route_id = 4;
 
 -- For the route ID 4, write a query to view the execution plan of the passengers_on_flights table.
 SELECT * FROM `passengers_on_flights` WHERE route_id=4;

-- calculate the total price of all tickets booked by a customer across different aircraft IDs using rollup function.
SELECT customer_id,aircraft_id, SUM(Price_per_ticket) as Total_sales FROM ticket_details GROUP BY customer_id,aircraft_id WITH ROLLUP;

-- create a view with only business class customers along with the brand of airlines.
SELECT customer_id, class_id, brand from ticket_details where class_id = 'Bussiness';

-- create a stored procedure to get the details of all passengers flying between 
-- a range of routes defined in run time. Also, return an error message if the table doesn't exist.
delimiter $$
SELECT passengers_on_flights * 
begin 
as 
when aircargo.routes.route_id between 0 to 50 as 'Flying route range' if not
then error as 'table doesnt exist' from passengers_on_flights;
end;
delimiter $$

-- create a stored procedure that extracts all the details from the routes table where the travelled distance is more than 2000 miles.
delimiter $$
CREATE procedure distance_miles()  
begin
select * from  routes where distance_miles > 2000;
end $$  

call distance_miles();

-- create a stored procedure that groups the distance travelled by each flight into three categories. The categories are, short distance travel (SDT) for >=0 AND <= 2000 miles, 
-- intermediate distance travel (IDT) for >2000 AND <=6500, and long-distance travel (LDT) for >6500.
select *,
case 
when distance_miles >=0 and distance_miles <= 2000 then "short distance travel (SDT)"
when distance_miles >2000 and distance_miles <= 6500 then "intermediate distance travel (IDT)"
when  distance_miles >6500 then "long-distance travel (LDT)"
end as categories
from routes;

-- extract ticket purchase date, customer ID, class ID and specify if the complimentary services are provided for the specific class using a stored function 
-- in stored procedure on the ticket_details table. 

SELECT p_date, customer_id, class_id,
case 
when class_id = 'Bussiness' or class_id = "Economy Plus" then 'Yes'
else 'No' 
end as Complimentary_Service
from ticket_details order by customer_id;

-- extract the first record of the customer whose last name ends with Scott using a cursor from the customer table.
SELECT * from customer where last_name = 'Scott';