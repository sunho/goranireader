create table books (
    id serial primary key,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    isbn character varying(30) not null,
    name character varying(1024) not null,
    author character varying(1024) not null,
    native_name character varying(1024),
    cover character varying(1024) not null,
    description character varying(4096) not null,
    categories character varying(1024) not null,
    rate double precision not null
);

create table book_epubs (
    id uuid not null,
    book_id integer references books on delete cascade primary key,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    epub character varying(1024)
);

create table book_sens (
    id uuid not null,
    book_id integer references books on delete cascade primary key,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    sens character varying(1024)
);

create table users (
    id serial primary key,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    username character varying(255) not null unique,
    email character varying(255) not null unique,
    password_hash character varying(255) not null
);

create table memories (
    id serial primary key,
    user_id integer references users on delete cascade,
    word character varying(100),
    sentence character varying(1024),
    rate double precision not null,
    unique(user_id, word)
);

create table rates (
    id uuid not null,
    user_id integer not null references users on delete cascade,
    target_id integer not null,
    kind character varying(1024),
    rate integer not null,
    primary key(target_id, kind, user_id)
);