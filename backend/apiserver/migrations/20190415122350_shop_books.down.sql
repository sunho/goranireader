drop view shop_books;

ALTER TABLE books 
ADD COLUMN rate double precision not null;