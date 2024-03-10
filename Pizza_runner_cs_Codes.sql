1.How many pizzas were ordered?

select count(order_id)total_pizzas 
from runner_orders_temp;


2.How many unique customer orders were made?

select count (distinct customer_id)unique_customer
from customer_orders_temp;


3.How many successful orders were delivered by each runner?

select count (order_id)successful_orders
from runner_orders_temp
where distance is not null;

4.How many of each type of pizza was delivered?

select count(c.pizza_id),p.pizza_name
from pizza_runner.customer_orders as c
inner join pizza_runner.pizza_names as p
on c.pizza_id=p.pizza_id
inner join runner_orders_temp as r
on c.order_id= r.order_id
where r.distance is not null
group by 2;


5.How many Vegetarian and Meat Lovers were ordered by each customer?

select count(c.order_id),p.pizza_name
from pizza_runner.customer_orders as c
inner join pizza_runner.pizza_names as p
on c.pizza_id=p.pizza_id
group by 2;

6.What was the maximum number of pizzas delivered in a single order?

select c.order_id,Count(c.order_id)Max_orders
from customer_orders_temp as c
inner join runner_orders_temp as r
on c.order_id= r.order_id
where distance is not Null
group by c.order_id
order by 2 desc
limit 1;

7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

select count(r.order_id)total
from customer_orders_temp as c
join runner_orders_temp as r
on c.order_id=r.order_id
where exclusions is not null and extras is not null and distance is not null


8)How many pizzas were delivered that had both exclusions and extras?\

select count(r.order_id)total
from customer_orders_temp as c
join runner_orders_temp as r
on c.order_id=r.order_id
where exclusions is not null and extras is not null and distance is not null

9.What was the total volume of pizzas ordered for each hour of the day?

select extract (hour from order_time)as hour_of_order,count(order_id)
from pizza_runner.customer_orders
group by 1
order by 2 desc;

10.What was the volume of orders for each day of the week?

select extract (dow from order_time)as day_of_week,count(order_id)
from pizza_runner.customer_orders
group by 1
order by 2 desc;






