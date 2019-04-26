create table target_book_progresses (
    id uuid not null,
    user_id integer references users on delete cascade,
    book_id integer references books on delete cascade,
    progress double precision not null,
    primary key(user_id, book_id)
);

alter table books
add column google_id character varying(1024) not null default '';
