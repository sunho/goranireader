create table classes (
    id serial primary key,
    name character varying(4096) not null,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null
);

create table class_missions (
    id serial primary key,
    class_id integer not null references classes on delete cascade,
    book_id integer not null references books on delete cascade,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    start_at timestamp without time zone not null,
    end_at timestamp without time zone not null
);

create table user_book_progresses (
    id uuid not null,
    user_id integer not null references users on delete cascade,
    book_id integer not null references books on delete cascade,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    read_pages integer not null,
    primary key (user_id, book_id)
);

alter table users
add column class_id integer;

alter table users
   add constraint fk_user_class
   foreign key (class_id)
   references classes (id) on delete set null;

