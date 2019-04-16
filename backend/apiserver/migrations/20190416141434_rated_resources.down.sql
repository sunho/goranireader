drop view detailed_memories;
drop view detailed_recommended_books;
alter table detailed_books
  rename to shop_books;

alter table memories
add column rate double precision not null default 0;