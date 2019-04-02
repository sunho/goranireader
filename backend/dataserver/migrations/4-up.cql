use gorani;

create table user_flipped_paragraphs (
    id uuid,
    user_id int,
    time timestamp,
    interval double,
    paragraph blob,
    primary key (user_id, id, time)
);
