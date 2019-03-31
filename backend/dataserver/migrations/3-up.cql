use gorani;

create table user_event_day_logs (
    id uuid,
    user_id int,
    day timestamp,
    kind varchar,
    time timestamp,
    payload text,
    primary key ((user_id, day), id, time)
);

create table user_event_kind_logs (
    id uuid,
    user_id int,
    day timestamp,
    kind varchar,
    time timestamp,
    payload text,
    primary key ((user_id, kind), id, time)
);
