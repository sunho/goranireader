create table classes (
    id serial primary key,
    name character varying(4096) not null,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null
);

create table class_missions (
    id serial primary key,
    class_id integer not null references classes on delete cascade,
    pages integer not null,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    start_at timestamp without time zone not null,
    end_at timestamp without time zone not null
);

create table user_mission_progresses (
    id uuid not null,
    user_id integer not null references users on delete cascade,
    mission_id integer not null references class_missions on delete cascade,
    created_at timestamp without time zone not null,
    updated_at timestamp without time zone not null,
    progress double precision not null,
    primary key (user_id, mission_id)
);


alter table users
add column class_id integer;

alter table users 
   add constraint fk_user_class
   foreign key (class_id) 
   references classes (id) on delete set null;

