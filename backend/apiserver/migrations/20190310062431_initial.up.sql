create table classes (
    id serial primary key,
    name character varying(4096) not null,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null
);

create table books (
    id character varying(255) not null primary key,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    name character varying(1024) not null,
    author character varying(1024) not null,
    cover character varying(4096) not null,
    download_link character varying(4096) not null
);

create table admins (
    id serial primary key,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    username character varying(255) not null unique,
    password_hash character varying(1024) not null
);

create table admins_classes (
    admin_id integer references admins on delete cascade,
    class_id integer references classes on delete cascade
);

create table invites (
    id serial primary key,
    invite character varying(255) not null unique,
    username character varying(255) not null unique
);

create table users (
    id serial primary key,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    username character varying(255) not null unique,
    class_id integer not null references classes on delete cascade,
    secret_code character varying(255) not null
);

create table memories (
    id serial primary key,
    user_id integer references users on delete cascade,
    word character varying(100),
    sentence character varying(1024),
    unique(user_id, word)
);

create table class_missions (
    id serial primary key,
    class_id integer not null references classes on delete cascade,
    book_id character varying(255) not null references books on delete cascade,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    start_at timestamp without time zone not null,
    end_at timestamp without time zone not null
);

create table user_book_progresses (
    id uuid not null,
    user_id integer not null references users on delete cascade,
    book_id character varying(255) not null references books on delete cascade,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    progress double precision not null,
    primary key (user_id, book_id)
);

