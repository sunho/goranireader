drop view shop_books;

alter table books 
add column rate double precision not null;