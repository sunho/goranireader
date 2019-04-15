alter table books 
drop column rate;

create view shop_books as select
    books.*,
    readable_books.difficulty,
    readable_books.user_id,
    book_rates.rate
from
    books
left join
    readable_books
on
    books.id = readable_books.book_id
left join
 (
  select
    rates.target_id,
    AVG(rates.rate) as rate
    from 
        rates
    where
        rates.kind = 'book'
    group by
        rates.target_id
) book_rates
on
    books.id = book_rates.target_id;
