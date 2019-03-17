create table words (
    id uuid not null,
    word character varying(100) primary key
);

create table categories (
    id serial primary key,
    name character varying(255) not null
);

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
    rate integer not null
);

create table books_categories (
    id uuid not null,
    book_id integer references books on delete cascade,
    category_id integer references categories on delete cascade,
    primary key(book_id, category_id)
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

create table book_words (
    id uuid not null,
    book_id integer references books on delete cascade,
    word character varying(100) references words(word) on delete cascade,
    n integer not null
);

create table users (
    id serial primary key,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    username character varying(255) not null,
    email character varying(255) not null,
    password_hash character varying(255) not null
);

create table sens_progresses (
    id uuid not null,
    user_id integer references users on delete cascade,
    book_id integer references books on delete cascade,
    sens_id integer not null,
    primary key(user_id, book_id)
);

create table sens_results (
    id uuid not null,
    user_id integer references users on delete cascade,
    book_id integer references books on delete cascade,
    sens_id integer not null,
    score integer not null,
    primary key(user_id, book_id, sens_id)
);

create table quiz_results (
    id uuid not null,
    user_id integer references users on delete cascade,
    book_id integer references books on delete cascade,
    quiz_id integer not null,
    score integer not null,
    primary key(user_id, book_id, quiz_id)
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

create table users_books (
    id uuid not null,
    user_id integer references users on delete cascade,
    book_id integer references books on delete cascade,
    primary key(user_id, book_id)
);

create table recommend_infoes (
    id uuid not null unique,
    user_id integer primary key references users on delete cascade,
    target_book_id integer
);

create table recommend_infoes_categories (
    id uuid not null,
    recommend_info_id uuid references recommend_infoes(id) on delete cascade,
    category_id integer references categories on delete cascade,
    primary key(recommend_info_id, category_id)
);

create table unknown_words (
    id uuid not null,
    user_id integer references users on delete cascade,
    word character varying(100),
    definitions character varying(4096),
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

create table known_words (
    id uuid not null,
    user_id integer references users on delete cascade,
    word character varying(100) references words(word) on delete cascade,
    n integer not null,
    primary key(user_id, word)
);



