select *
from details d
join numbers n on d.id = n.details_id
join quotes q on d.id = q.details_id
--where d.name = 'Jim'
--where d.name like 'Je%'
--or d.name like 'Ji%'
--where n.n2::text = '2'
--where n.n2::text like '2%'
order by d.id