-- Business Problems and solutions

select * from trips;
select * from trips_details;


-- Total number of trips
select count(distinct tripid)as counts 
from trips_details;

select tripid, count(tripid)as counts 
from trips_details
group by 1
having count(tripid)>1;


-- Total number of drivers
select count(distinct driverid)as total_drivers
from trips;


-- Total number of earnings
select sum(fare)as total_earnings
from trips;


-- Total number of completed trips
select count(end_ride)as completed_trips
from trips_details
where end_ride=1;


-- Total number of searches
select sum(searches)as searches 
from trips_details;

-- Total number of searches which got estimate
select sum(searches_got_estimate)as searches_got_estimate 
from trips_details;


-- Total number of searches for quotes
select sum(searches_for_quotes)as searches_for_quotes 
from trips_details;


-- Total number of searches which got quotes
select sum(searches_got_quotes)as searches_got_quotes 
from trips_details;


-- Total number of trips which were cancelled by drivers
select count(*)-sum(driver_not_cancelled)as cancelled_by_drivers 
from trips_details;


-- Total number of trips which were cancelled by customers
select count(*)-sum(customer_not_cancelled)as cancelled_by_customers
from trips_details;


-- Total number of trips where OTP is entered
select sum(otp_entered)as otp_entered
from trips_details;


-- Average distance per trip
select avg(distance)as avg_distance 
from trips;


-- Average fare per trip
select avg(fare)as avg_fare
from trips;


-- Total distance travelled by customers
select sum(distance)as avg_distance 
from trips;


-- Which is the most used payment method
select faremethod, count(faremethod)as most_used_payments
from trips
group by 1
order by 2 desc;


-- Select the mode of payment which is widely used
select a.method, most_used_payments
from payment a
inner join (select faremethod, count(faremethod)as most_used_payments
from trips
group by 1)as b
on a.id=b.faremethod
order by 2 desc;


-- Find the highest payment from the entire trip
select * from trips
order by fare desc;


-- Which locations had the most trips
select * from 
(select *, dense_rank() over(order by number_of_trips desc)as rank 
from
(select loc_from, loc_to, count(distinct tripid)as number_of_trips
from trips
group by 1, 2)as tb1)
where rank=1;


-- Top 5 earning drivers
select * from 
(select *, dense_rank() over(order by earnings desc)as rank 
from
(select driverid, sum(fare)as earnings
from trips
group by driverid)as a)as b
where rank<6;


-- Which duration had most trips
select * from
(select *, dense_rank() over(order by num_of_trips desc)as rank
from(select duration, count(distinct tripid)as num_of_trips 
from trips
group by 1)as a)as b
where rank = 1;


-- Which driver and customer pair had more trips
select * from
(select *,dense_rank() over(order by total_trips desc)as rank
from(select driverid, custid, count(distinct tripid)as total_trips 
from trips
group by 1, 2)as a)as b
where rank=1;


-- Search to estimate rate
select sum(searches_got_estimate)*100.0/sum(searches)as searches_got_estimate_rate 
from trips_details;


-- Estimate to search for quote rates
select * from trips_details
select sum(searches_for_quotes)*100.0/sum(searches)as searches_for_quotes_rate
from trips_details;


-- Quote Acceptance rates
select sum(searches_got_quotes)*100.0/sum(searches)as searches_got_quotes_rate
from trips_details;


-- Quote to booking rate
select sum(customer_not_cancelled)*100.0/sum(searches)as quote_to_booking_rate
from trips_details;


-- Booking cancellation rates
select (count(*)-sum(customer_not_cancelled))*100.0/sum(searches)as quote_to_booking_rate
from trips_details;


-- Conversion rates
select sum(end_ride)*100.0/sum(searches)as conversion_rate
from trips_details;


-- Which area got highest trips in each duration
select * from
(select *, dense_rank() over(partition by duration order by counts desc)as rank
from
(select duration, loc_from, count(distinct tripid)as counts 
from trips
group by 1, 2)as a)as b
where rank=1;


-- Which duration got highest trips in each area
select * from
(select *, dense_rank() over(partition by loc_from order by counts desc)as rank
from
(select duration, loc_from, count(distinct tripid)as counts 
from trips
group by 1, 2)as a)as b
where rank=1;


-- Which area got the highest fares, cancellations, trips
select * from trips;
select * from trips_details;

select * from
(select *, dense_rank() over(order by total_fare desc)as rank
from(select loc_from, sum(fare)as total_fare 
from trips 
group by 1)as a)as b
where rank=1

	
select * from
(select *, dense_rank() over(order by driver_cancelled desc)as rank
from(select loc_from, count(*)-sum(driver_not_cancelled)as driver_cancelled
from trips_details
group by 1)as a)as b
where rank=1


select * from
(select *, dense_rank() over(order by customer_cancelled desc)as rank
from(select loc_from, count(*)-sum(customer_not_cancelled)as customer_cancelled
from trips_details
group by 1)as a)as b
where rank=1


-- Which duration got highst trips and fares
select * from
(select *, dense_rank() over(order by total_fare desc)as rank
from(select duration, sum(fare)as total_fare 
from trips 
group by 1)as a)as b
where rank=1


select * from
(select *, dense_rank() over(order by cnt desc)as rank
from(select duration, count(distinct tripid)as cnt 
from trips 
group by 1)as a)as b
where rank=1