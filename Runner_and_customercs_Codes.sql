1.How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

select count(runner_id)total runners
from pizza_runner.runners
where registration_date between '2021-01-01'::Date and '2021-01-01'::Date + INTERVAL '7 DAY';


2.What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pick up the order?

WITH my_cte AS (
    SELECT
        r.order_id, r.runner_id,
        EXTRACT(EPOCH FROM r.pickup_time - c.order_time) / 60 AS Time_took_by_rider_to_arrive
    FROM
        pizza_runner.customer_orders AS c
        INNER JOIN pizza_runner.runner_orders AS r ON c.order_id = r.order_id
    WHERE
        r.cancellation IS NULL
)
SELECT
   m.runner_id,
   m. Time_took_by_rider_to_arrive,
   AVG(Time_took_by_rider_to_arrive)AS avg_time_took_by_rider_to_arrive
FROM
    my_cte AS m
GROUP BY
    m.runner_id, Time_took_by_rider_to_arrive;

3.Is there any relationship between the number of pizzas and how long the order takes to prepare?

SELECT r.order_id,
       COUNT(c.order_id) AS Count_of_pizzas, 
       EXTRACT(EPOCH FROM r.pickup_time - c.order_time) / 60 AS date_difference_minutes
FROM pizza_runner.customer_orders AS c
INNER JOIN pizza_runner.runner_orders AS r ON c.order_id = r.order_id
 where r.cancellation is null
GROUP BY r.order_id,c.order_time,r.pickup_time
order by date_difference_minutes desc; 

4. What was the average distance travelled for each customer?

select c.customer_id,Round(avg(r.distance),2)avg_distance_travlled
from pizza_runner.customer_orders AS c
INNER JOIN pizza_runner.runner_orders AS r ON c.order_id = r.order_id
group by c.customer_id;

5.What was the difference between the longest and shortest delivery times for all orders

WITH my_cte AS (
    SELECT
        CASE
            WHEN duration ~ '^\d{2}$' THEN CAST(duration AS INTEGER) -- Check if it's a 2-digit number
            ELSE NULL -- Set non-numeric values or unexpected formats as NULL
        END AS duration_1
    FROM pizza_runner.runner_orders
)
SELECT MAX(duration_1)- MIN(duration_1) AS diff_of_duration
FROM my_cte;

6.What was the average speed for each runner for each delivery and do you notice any trend for these values?

WITH my_cte AS (
    SELECT
        runner_id,
        order_id,
        distance,
        duration,
        CAST(distance AS DECIMAL) / CAST(duration AS DECIMAL) AS calculated_speed
    FROM
        pizza_runner.runner_orders
    WHERE
        distance IS NOT NULL)

SELECT
    runner_id,
    calculated_speed AS speed,
    AVG(calculated_speed) AS avg_speed
FROM
    my_cte
GROUP BY
    runner_id, calculated_speed;

 7.What is the successful delivery percentage for each runner?

with my_cte AS (
SELECT
    runner_id,count(*) as total_sucessful_orders
FROM
    pizza_runner.runner_orders
WHERE
    cancellation IS NULL
GROUP BY
1
),
my_cte_2 AS ( 
select 
runner_id,count(*) as total_orders
FROM
    pizza_runner.runner_orders
GROUP BY
1
)
select a.runner_id,b.total_sucessful_orders,a.total_orders, Round((100.0 *b.total_sucessful_orders/a.total_orders ),2)AS percentage_of_sucessful_order
from my_cte_2 as a
inner join my_cte  as b
on a.runner_id=b.runner_id
group by a.runner_id,b.total_sucessful_orders,a.total_orders;









