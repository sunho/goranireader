create table readable_books (
    id uuid not null,
    user_id integer references users on delete cascade,
    book_id integer references books on delete cascade,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    difficulty integer not null,
    primary key(user_id, book_id)
);

create table recommended_books (
    id uuid not null,
    user_id integer references users on delete cascade,
    book_id integer references books on delete cascade,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    primary key(user_id, book_id)
);