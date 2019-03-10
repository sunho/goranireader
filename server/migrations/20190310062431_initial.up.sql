create table users (
    id serial primary key,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    username character varying(255) not null,
    email character varying(255) not null,
    password_hash character varying(255) not null
);

create table recommend_infos (
    id uuid not null,
    user_id integer primary key references users on delete cascade,
    target_book_id integer references books on delete cascade
);

create table recommend_info_categories (
    id uuid not null,
    recommend_info_id uuid references recommend_infos on delete cascade,
    category_id integer references categories on delete cascade
);

create table categories (
    id serial primary key,
    name character varying(255) not null
);

create table reviews (
    id serial primary key,
    book_id integer references books on delete cascade,
    user_id integer references users on delete cascade,
    content character varying(1024) not null,
    rate integer not null
);

create table review_rates (
    id uuid not null,
    review_id integer references reviews on delete cascade,
    user_id integer references users on delete cascade,
    rate integer not null,
    primary key(review_id, user_id)
);

create table books (
    id serial primary key,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null
    isbn character varying(30) not null,
    name character varying(1024) not null,
    native_name character varying(1024),
    cover character varying(1024) not null,
    description character varying(4096) not null
);

create table book_categories (
    id uuid not null,
    book_id integer references books on delete cascade,
    category_id integer references categories on delete cascade,
    primary key(book_id, category_id)
);

create table book_senses (
    id uuid not null,
    book_id integer references books on delete cascade primary key,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    sens character varying(1024) not null
);

create table book_quizes (
    id uuid not null,
    book_id integer references books on delete cascade primary key,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    quiz character varying(1024) not null
);

create table book_epubs (
    id uuid not null,
    book_id integer references books on delete cascade primary key,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    epub character varying(1024) not null
);

create table book_words (
    id uuid not null,
    book_id integer references books on delete cascade,
    word character varying(100) references words on delete cascade,
    n integer not null
);

create table words (
    word character varying(100) primary key
);

create table unknown_words (
    id uuid not null,
    user_id integer references users on delete cascade,
    word character varying(100),
    definitions character varying(4096),
    primary key(user_id, word)
);

create table known_words (
    id uuid not null,
    user_id integer references users on delete cascade,
    word character varying(100) references words on delete cascade,
    n integer not null,
    primary key(user_id, word)
);

create table memories (
    id serial primary key,
    user_id integer references users on delete cascade,
    word character varying(100),
    sentence character varying(1024)
);

create table memory_rates (
    id uuid not null,
    memory_id integer references memories on delete cascade,
    user_id integer references users on delete cascade,
    word character varying(100),
    rate integer not null,
    primary key(memory_id, user_id)
);



