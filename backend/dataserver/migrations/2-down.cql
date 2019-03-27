use gorani;

drop table book_similarity;

create table book_similarity (
    id int,
    other_id int,
    value double,
    primary key (id, other_id)
);
