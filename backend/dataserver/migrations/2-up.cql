use gorani;

drop table book_similarity;

create table book_similarity (
    id int,
    type varchar,
    other_id int,
    value double,
    primary key (id, type, other_id)
);
