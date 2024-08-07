
-- Q1. find the name of the customers who never ordered
select name 
from users
where user_id not in (select user_id from orders);





-- Q2. find average amount of dishes
select f.f_name,avg(price) as avg_price
from menu m
join food f
on m.f_id=f.f_id
group by f.f_name;



-- Q3. find top restaurant in each month based on no of orders
select r.r_name, monthname(date) as month,count(*) as total_order
from orders o
join restaurants r
on o.r_id = r.r_id
where monthname(date) like 'june'
group by r.r_name,monthname(date)
order by count(*) desc limit 1;
-- Q4.Restaurants with monthly sales >x
select r.r_name ,monthname(date) as month ,sum(amount) as revenue
from orders o
join restaurants r
on o.r_id= r.r_id
where monthname(date) like 'july'
group by r.r_name, monthname(date)
having sum(amount)  > 500
order by revenue desc;


-- Q5. ordet details of specific customer in given date range
 select o.order_id,r.r_name,f.f_name
 from orders o
 join restaurants r
 on o.r_id = r.r_id
 join order_details od 
 on o.order_id=od.order_id
 join food f
 on f.f_id=od.f_id
 
 where user_id  in (select user_id
 from users 
 where name like 'nitish') and
date between '2022-06-10'and '2022-07-10';

-- Q 6. find the restaurant with most repeated customers
select r.r_name,count(*) as loyal_customer
from (
select r_id, user_id, count(*) as visits
from orders o
group by r_id,user_id
having visits >1) t
join restaurants r
on r.r_id=t.r_id
group by r.r_name
order by loyal_customer desc limit 1;
-- Q7.  find month over month growth of swiggy......

 select month ,((revenue-prev)/prev)*100 as growth
from (
 with sales as
 (
   select month(date) as 'month', sum(amount) as 'revenue'
   from orders
   group by month
   order by month
  ) 
  select month, revenue,lag(revenue,1) over(order by month ) as prev from sales
) t ;

-- Q8.find the favourite food of every customer

with temp as 
(  
   select o.user_id,od.f_id, count(*) as frequency
   from orders o
   join order_details od
   on o.order_id=od.order_id
   group by o.user_id,od.f_id
 )
select u.name,f.f_name, t1.frequency from
temp t1
join users u
on u.user_id=t1.user_id
join food f
on f.f_id=t1.f_id
where t1.frequency = (
      select max(frequency)
      from temp t2
      where t2.user_id=t1.user_id
      )

group by u.name,f.f_name, t1.frequency