use gorani;

create table books (
    id int,
    name varchar,
    content list<varchar>,
    primary key (id, name)
);

create table book_similarity (
    id int,
    other_id int,
    value double,
    primary key (id, other_id)
);