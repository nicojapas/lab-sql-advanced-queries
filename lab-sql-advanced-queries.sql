-- 1
use sakila;
select
	concat(act1.first_name, ' ', act1.last_name) as full_name1,
	s1.id1,
    concat(act2.first_name, ' ', act2.last_name) as full_name2,
    s1.id2
from actor as act1
right join
(
select t1.actor_id as id1, t2.actor_id as id2
from film_actor as t1, film_actor as t2
where t1.film_id = t2.film_id
group by t1.actor_id, t2.actor_id
having t1.actor_id != t2.actor_id
and t1.actor_id < t2.actor_id
order by t1.actor_id asc, t2.actor_id asc
) s1
on act1.actor_id = s1.id1
left join actor as act2
on act2.actor_id = s1.id2;
-- 2
select
	s2.film_id,
    concat(act.first_name, " ", act.last_name) as full_name
from (
	select
		*,
		dense_rank() over(order by s1.n_films desc) as ranked
	from (
		select
			film_id,
			actor_id,
			count(*) as n_films
		from film_actor
		group by actor_id
	) s1
order by s1.film_id asc, ranked asc
) s2
join
actor as act
using(actor_id)
group by s2.film_id
order by film_id asc;