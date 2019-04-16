alter table memories 
drop column rate;

alter table shop_books
  rename to detailed_books;

create view detailed_recommended_books as select
    recommended_books.*,
    rates.rate
from
    recommended_books
left join
    rates
on
    recommended_books.book_id = rates.target_id
and
    recommended_books.user_id = rates.user_id
and
    rates.kind = 'recommended_book';

create view detailed_memories as select
    memories.*,
    memory_rates.rate
from
    memories
left join
 (
  select
    rates.target_id,
    AVG(rates.rate) as rate
    from 
        rates
    where
        rates.kind = 'memory'
    group by
        rates.target_id
) memory_rates
on
    memories.id = memory_rates.target_id;