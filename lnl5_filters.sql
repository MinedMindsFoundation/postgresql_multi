select *
from details d
left join numbers n on d.id = n.details_id
left join quotes q on d.id = q.details_id
--where d.name = 'Jim'  -- equals filter
--where d.name like 'Ji%'  -- partial match on beginning of string
--where d.name like '%n'  -- partial match on end of string
--where d.name like '%e%'  -- partial match on any part of string
--where d.name like 'Je%'  -- multiple partial matches
--or d.name like 'Ji%'
--where n.n2::text = '2'  -- equals filter for integer
--where n.n2::text like '2%'  -- partial match on beginning of integer
--where n.n2::text like '%2'  -- partial match on end of string
--order by d.id  -- order by details table's id column
--order by d.name  -- order results by details table's name column